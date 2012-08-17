with Ada.Text_IO;         use Ada.Text_IO;
with Sockets;             use Sockets;

package body Server is



   procedure Start_Server(Chat_Sockets : out Chat_Record;
                          Game_Sockets : out Player_Record) is
         Accepting_Socket : Socket_Fd;
         Game_Socket      : Socket_Fd;

         Players : Player_record;
         Chats   : Chat_Record;



      begin

         Put_Line("Chess server v0.99         Copyright 2004");
         Put_Line("=========================================");

         Put_Line("Starting server.");
         Socket(Accepting_Socket);
         Socket(Game_Socket);

         Setsockopt(Accepting_Socket, SOL_SOCKET, SO_REUSEADDR, 1);
         setsockopt(Game_Socket, SOL_SOCKET, SO_REUSEADDR, 1);

         Bind(Accepting_Socket, 5040);
         Bind(Game_Socket, 5041);

         Listen(Accepting_Socket);
         Listen(Game_Socket);

         Put_Line("-> Server started.");

         -- Ta emot spelare
         for I in 1..4 loop

            Put_Line("Waiting for a client" & Integer'Image(I));
            Accept_Socket(Accepting_Socket, Chats(I));
            Accept_Socket(Game_Socket,Players(I));
            Put_Line("-> Client" & Integer'Image(I) & " connected.");

         end loop;

         Put_line("All players connected. Awaiting task start.");

         -- Tilldela out variabler
         Game_Sockets := Players;
         Chat_Sockets := Chats;

      end Start_Server;


   procedure Send_To_All(Players: in Chat_Record;
                         Text: in String) is

   begin
      for I in 1..4 loop
         begin
            Put_Line(Players(I), Text);
         exception
            when Connection_Closed =>
               Put_Line("-> Client disconnected.");
               --Shutdown(Players(I));
               null;
         end;
      end loop;
   end Send_To_All;



task body Chat_Task is

      My_Socket: Socket_FD;
      Chat_Msg : String(1..85);
      Chat_Clients : Chat_Record;
      I : Integer;
      Receivers : array(1..4) of Boolean := (others => False);

   begin
      accept Start(Socket : in Socket_Fd;
                   Chat_List : in Chat_Record) do
         My_Socket := Socket;
         Chat_Clients := Chat_List;


         --första 1,2,3,4,5 från spelare
         --andra 1,2,3,4,A till spelare
      end Start;
      loop
         begin
            Get_Line(My_Socket, Chat_Msg,I);
         exception
            when Connection_Closed =>
               Put_Line("-> Client disconnected.");
               Shutdown(My_socket);
               null;
         end;
         Put_Line("-> Message bounced.");
         if Chat_Msg(2) = 'A' then
            Receivers := (others => True);
         else
            Receivers(Integer'Value(Chat_Msg(2..2))) := True;
            Receivers(Integer'Value(Chat_Msg(1..1)))  := True;
         end if;

         for J in 1..4 loop
            begin
               if Receivers(J) then
                  Put_line(Chat_Clients(J),Chat_Msg(1..I));
               end if;
            exception
               when Connection_Closed =>
                  Put_Line("-> Client disconnected.");
                  Shutdown(Chat_Clients(J));
                  --abort;
                 null;
            end;
         end loop;
      end loop;
   end Chat_Task;

end Server;

