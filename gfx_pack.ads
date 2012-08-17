with Chess_Pack;            use Chess_Pack;

package Gfx_Pack is

--=============================================================================
   procedure Gfx_Init(In_Player_ID : in Positive; In_Name_Arr : in Name_Arr_Type);
   procedure Gfx_Init;
   -- Call this before anything else. In_Player_ID is range 1..4, and all four
   -- names must be present in In_Name_Arr when called (i.e. no way to add
   -- people later).

--=============================================================================
   function  Gfx_Update return String;
   -- Returns a string starting with "MOVE " or "CHAT ".
   -- As soon as this function returns, it should be called again.
   -- It is inside this function that all graphics stuff is updated.
   -- In other words: while not called, the screen will stand still.

--=============================================================================
   procedure Gfx_Exit;
   -- Hopefully restores everything to the way it was before.

--=============================================================================
   procedure Gfx_Send_Move(Drag : Drag_Record);
   -- Send a move string (format XX-XX-XX-XX-X) to this one and the graphics
   -- will be updated.

--=============================================================================
   procedure Gfx_Send_Chat(In_Str : in String);
   -- Send chat strings to this procedure. Format: "XY<message>", where X is
   -- sender ID, and Y is recipient ID, or 'A' for all players.
   -- NB: The graphics pack won't care about Y, so don't send anything that
   -- shouldn't be sent to the respective client. If you do, the message will
   -- be printed regardless of the recipient ID.
   -- Q: Why is it done this way?
   -- A: Because messages sent to the wrong recipient is unnecessary network
   --    traffic, and this is a good way to test if such errors occur.

--=============================================================================
   procedure Gfx_Send_Time(In_Time : in Integer);
   -- Draws the time.

--=============================================================================
   procedure Gfx_Send_Win(Win_Mode : in Win_Mode_Type; Player_Won : Positive);
   -- Tells the graphics that a player has won

--=============================================================================
   procedure Gfx_Draw_All;
   -- Draws all graphics and text. Needless to say, takes a while.
--=============================================================================
   procedure Gfx_Intro;
   -- Draws a small presentation of the game

end Gfx_Pack;
