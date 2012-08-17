with Gfx_Pack;                      use Gfx_Pack;
with Client;                        use Client;
with Sockets;                       use Sockets;
with Ada.Command_Line;              use Ada.Command_Line;
with Ada.Exceptions;                use Ada.Exceptions;
with Ada.Text_Io;                   use Ada.Text_Io;
with Chess_Pack;                    use  Chess_Pack;
with Ada.Integer_Text_Io;           use Ada.Integer_Text_IO;
with Ada.Unchecked_Deallocation;


--slimmad client detta är minimalt!

procedure Client_Test is



      task type Time_Count_Task is
   entry Turn(Pl : in Boolean);
   entry Sock(FD : in Socket_FD);
   entry Drag(Str : in String);
end Time_Count_Task;

task body Time_Count_Task is

   Du  : Boolean := False;
   Serv : Socket_FD;
   Text : String(1..13);
   Skicka : Boolean := False;

begin

   accept Sock(FD : in Socket_FD) do
      Serv := FD;
   end Sock;
   loop
      if Du then
         Game_Rec.Tid := Game_Rec.Tid - 1;
         Gfx_Send_Time(Game_Rec.Tid);
         if Game_Rec.Tid = 0 then
            Text :=  "01-01-14-14-8";
            Skicka := True;
         end if;
         if Skicka then
            Put_Line(Serv, Text);
            Skicka := False;
         end if;
         select
            accept Drag(Str : in String) do
               Text := Str;
               Skicka := True;
            end Drag;
         or
            accept Turn(Pl : in Boolean) do
               Du := Pl;

            end Turn;
         or
            delay 1.0;
            null;
         end select;
      else
         select
            accept Turn(Pl : in Boolean) do
               Du := Pl;
            end Turn;
         or
            delay 1.0;
            null;
         end select;
      end if;
   end loop;
end Time_Count_Task;


type A_T is access Time_Count_Task;

   procedure Free is new
     Ada.Unchecked_Deallocation(Time_Count_Task, A_T);




task type Vis_String_Task is
   entry Ptr(Rr : in A_T);
   entry Sock_Send(Sock : in Socket_FD);
end Vis_String_Task;

task body Vis_String_Task is

   Str : String(1..Max_Str_Len);
   Du  : Boolean := False;
   T   : A_T;
   Chat_Sock : Socket_FD;

begin
   accept Sock_Send(Sock : in Socket_FD) do
      Chat_Sock := Sock;
   end Sock_Send;
   accept Ptr(Rr : in A_T) do
      T := Rr;
   end Ptr;
   loop
      Str := Gfx_Update;
      if Str(1..4) = "MOVE" then
         T.Drag(Str(6..18));
      elsif  Str(1..4) = "CHAT" then
         Put_Line(Chat_Sock, Str(6..Max_Str_Len));
      end if;
   end loop;
end Vis_String_Task;



      T        : A_T := new Time_Count_Task;
      V        : Vis_String_Task;
      Winner   : Integer;
      W_Mode   : Win_Mode_Type;
      Drag_Str : String(1..13) := (others => ' ');
      Drag_Rec : Drag_Record;
      Game      : Socket_FD; --game socket, alla drag sköts via denna
      Chat      : Socket_FD; -- chat socket, tar emot och skickar chatmsgs
      Chat_Task : Receiver;  -- tar emot chatmeddelanden


begin
   --Kopplar up
   if Argument_Count /= 1 then
      Raise_Exception(Constraint_Error'Identity,"Usage: "
                      & Command_Name & " remotehost");
   end if;
   Start_Client(Chat, Game,Argument(1)); --starta clienta
   Chat_Task.Start(Chat);   -- start chat_task

   --Get namn
   Put_Line(Get_Line(Game));
   Get_Line(Drag_Str, Game_Rec.Me);
   if Game_Rec.Me = 13 then
      Skip_Line;
   end if;
   Put_Line(Game, Drag_Str(1..11));
   Put_Line(Get_Line(Game));

   --Bygger Game_Rec
   Game_Rec.Me := Integer'Value(Get_Line(Game)(2..2));
   Game_Rec.Tid_Str := Get_Line(Game);
   Game_Rec.Kill_Str := Get_Line(Game);
   Game_Rec.Pts_Str := Get_Line(Game);
   for I in 1..4 loop
      Game_Rec.Namn(I).Str := Get_Line(Game);
      for J in reverse 1..12 loop
        if Game_Rec.Namn(I).Str(J) /= ' ' then
           Game_Rec.Namn(I).Str_Len := J;
           exit;
        end if;
      end loop;
      Game_Rec.Namn(I).Player_ID := I;
   end loop;
   Game_Rec.Namn(5).Str := "**Servern** ";
   Game_Rec.Namn(5).Str_Len := 11;
   Game_Rec.Namn(5).Player_ID := 5;
   Data_Convert(Game_Rec);

   -- Klar med Game_Rec, startar Tasks/init Grafiken!
   Gfx_Init;
   Gfx_Intro;
   T.Sock(Game);
   V.Sock_Send(Chat);
   V.Ptr(T);

   loop
      Drag_Rec.Player := (Drag_Rec.Player mod 4) + 1;
      if Alive(Drag_Rec.Player) then
         if Drag_Rec.Player = Game_Rec.Me then
            T.Turn(True);
         end if;
         Drag_Str := Get_Line(Game);
         T.Turn(False);
         Convert(Drag_Str, Drag_Rec);
         Tot_Move(Drag_Rec);
         Gfx_Send_Move(Drag_Rec);
         C_Winner(Drag_Rec.Player, Game_Rec, W_Mode, Winner);
         if W_Mode /= None then
            Shutdown(Game);
            Shutdown(Chat);
            Gfx_Send_Win(W_Mode, Winner);
            exit;
         end if;
      else
         if not  (Alive(1) or Alive(2) or Alive(3) or Alive(4)) then
            delay 10.0;
         end if;
      end if;
   end loop;
   Put_Line("Go home... there is nothing to see!");
   abort Chat_Task;
   abort T.all;
   abort V;
   Free(T);
   --terminate tasks close sockets free pointers...

end Client_Test;
