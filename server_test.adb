with Sockets;              use Sockets;
with Ada.Command_Line;     use Ada.Command_Line;
with Ada.Exceptions;       use Ada.Exceptions;
with Ada.Text_Io;          use Ada.Text_Io;
with Chess_Pack;           use Chess_Pack;
with Rule_Pack;            use Rule_Pack;
with Ada.Integer_Text_Io;  use Ada.Integer_Text_IO;
with Server;               use Server;

-- Slimmat server program
-- Detta är minimalt!!!

procedure Server_test is

   Chat      : Chat_Record;     -- chat_sockets
   Game      : Player_Record;   -- game_sockets
   Task_List : Chat_Tasks;      -- chat tasks
   Drag_Rec  : Drag_Record;
   Drag_Str  : String(1..13);
   Game_Rec  : Game_Rec_Type;


begin
      --Vinstkrav/betänketid Game_Rec fylls
      Get_Data(Game_Rec);

      Start_Server(Chat, Game);
      for I in 1..4 loop
         Task_List(I).Start(Chat(I), Chat);
         -- starta tasks! måsta vara aktiva in denna begin->end
      end loop;
      Put_Line("-> Chat tasks started.");
      for I in 1..4 loop
         Put_Line(Game(I), "Skriv in namn, max 11 tecken!");
         Game_Rec.Namn(I).Str(1..11) := Get_Line(Game(I));
         Put_Line(Game(I), "Väntar på övriga spelare!");
      end loop;
      --Game_Rec komplett, skickar Game_Rec
      for I in 1..4 loop
         Put_Line(Game(I), Integer'Image(I));
         Put_Line(Game(I), Game_Rec.Tid_Str);
         Put_Line(Game(I), Game_Rec.Kill_Str);
         Put_Line(Game(I), Game_Rec.Pts_Str);
         for K in reverse 1..12 loop
            if Game_Rec.Namn(I).Str(K) /= ' ' then
               Game_Rec.Namn(I).Str_Len := K;
               exit;
            end if;
         end loop;
         for J in 1..4 loop
            Put_Line(Game(I), Game_Rec.Namn(J).Str);
         end loop;
      end loop;

      -- game loop

      loop
         Drag_Rec.Player := (Drag_Rec.Player mod 4) + 1;
         if Alive(Drag_Rec.Player) then
            Drag_Str := Get_Line(Game(Drag_Rec.Player));
            Convert(Drag_Str, Drag_Rec);
            Cont(Drag_Rec);
            Str_Mod(Drag_Str, Drag_Rec);
            for I in 1..4 loop
               Put_Line(Game(I), Drag_Str);
            end loop;
            Tot_Move(Drag_Rec);
            S_Winner(Drag_Rec.Player, Game_Rec, Chat);
         end if;
         exit when Game_Rec.Legal;
      end loop;
      Put_Line("-> Game ended.");
      --Avsluta sockets, tasks...
      for I in 1..4 loop
        abort Task_List(I);
        Shutdown(Chat(I));
        Shutdown(Game(I));
      end loop;

end Server_Test;
