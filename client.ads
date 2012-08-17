with Sockets;              use Sockets;

package Client is

   procedure Start_Client(Chat_Socket: out Socket_FD;
                          Game_Socket: out Socket_FD;
                          Host       : in String);

   task type Receiver is
      entry Start(chat: in Socket_Fd);
   end Receiver;

end Client;
