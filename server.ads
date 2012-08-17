with Ada.Text_IO;     use Ada.Text_IO;
with Sockets;         use Sockets;

package Server is

   type Chat_Record is array(1..4) of Socket_FD;
   task type Chat_Task is
      entry Start(Socket : in Socket_Fd;
                  Chat_List: in Chat_Record);
   end Chat_Task;

   type Player_Record is array(1..4) of Socket_FD;

   type Chat_Tasks is array(1..4) of Chat_Task;
   procedure Start_Server(Chat_Sockets : out Chat_Record;
                         Game_Sockets  : out Player_Record);
   procedure Send_To_All(Players : in Chat_Record;
                         Text    : in String);

end Server;
