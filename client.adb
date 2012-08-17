with Ada.Text_IO;         use Ada.Text_IO;
with Sockets;             use Sockets;
with Gfx_Pack;            use Gfx_Pack;

Package body Client is

   task body Receiver is
      Sock : Socket_Fd;
   begin
      accept Start(Chat: in Socket_Fd) do
         Sock := chat;
            end Start;
      loop
         begin
            Gfx_Send_chat(Get_Line(Sock));
         exception
            when Connection_Closed=>
              Gfx_Send_Chat("5ALost track of server.");
              Shutdown(Sock);
         end;
      end loop;
   end Receiver;

   procedure Start_Client(Chat_Socket: out Socket_FD;
                          Game_Socket: out Socket_FD;
                          Host       : in String) is


      Chat : Socket_FD;
      Game : Socket_FD;
   begin
      Socket(Chat);
      Socket(Game);
      Connect(Chat, Host, 5040);
      Connect(Game, Host, 5041);
      Put_Line("Client connected.");

      Chat_Socket := Chat;
      Game_Socket := Game;

   end;



end Client;
