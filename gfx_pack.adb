with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with TJa.Window;            use TJa.Window;
with TJa.Window.Graphic;    use TJa.Window.Graphic;
with TJa.Window.Text;       use TJa.Window.Text;
with TJa.Keyboard;          use TJa.Keyboard;
with TJa.Keyboard.Keys;     use TJa.Keyboard.Keys;
with TJa.Misc;              use TJa.Misc;   -- bra å ha om man vill pipa lite
with Chess_Pack;            use Chess_Pack;
with Rule_Pack;             use Rule_Pack;

-- TODO:
-- Per: slå egen spelare tillåtet
-- Fixa det jävla bold-joxet
-- Skriv ut rätt poäng och grejer längst ner
-- Skriv ut nåt om man vinner

package body Gfx_Pack is

   Player_Id      : Natural;
   Player_To_Move : Natural;

   Name_Arr       : Chess_Pack.Name_Arr_Type;

   type Play_Mode_Type is (Game_E, Chat_E);
   type Move_Mode_Type is (From_E, To_E);
   Play_Mode : Play_Mode_Type;
   Move_Mode : Move_Mode_Type;

   Cursor_X      : Natural;
   Cursor_Y      : Natural;
   Cursor_Chat   : Natural;

   Chat_Offset  : constant := 62;
   Chat_Width   : constant := 100;
   Chat_Name_W  : constant := 19;
   Chat_Lines   : constant := 25;
   Chat_Str_Max : constant := 78;
   type Chat_Entry_Type is
      record
         Player_ID    : Natural := 0;
         Private_Flag : Boolean := False;
         Mess         : String(1 .. Chat_Width - Chat_Name_W - 4) := (others => ' ');
      end record;

   Chat_History     : array (1..Chat_Lines) of Chat_Entry_Type;
   Chat_Str         : String(1..Chat_Str_Max);
   Chat_To_ID       : Integer;

   From_X, From_Y   : Natural;

   Colour_LUT       : constant array (0..5) of Colour_Type := (White, Magenta, Red, Green, Yellow, White);
   Man_LUT          : constant array (0..6) of Character := (' ', 'B', 'T', 'S', 'L', 'D', 'K');
--   Man_Str_LUT      : constant array (0..6) of String :=
--     ("tom   ", "bonde ", "torn  ", "häst  ", "löpare", "dam   ", "kung  " );

   Status_Offset : constant := 12;
   Status_Width  : constant := 14;
   Status_Y      : constant := 31;


--=============================================================================
   procedure Restore_Cursor is
   begin
      if Play_Mode = Game_E then
         Goto_XY(4*Cursor_X - 1, 2*Cursor_Y);
      else
         Goto_XY(Chat_Offset + Chat_Name_W + 1 + Cursor_Chat, Chat_Lines + 3);
      end if;
      Set_Foreground_Colour(Colour_LUT(Player_ID));

   end Restore_Cursor;


--=============================================================================
   procedure Convert_Coos(X, Y: in out Integer) is
      XC, YC : Integer;
   begin
      case Player_ID is
         when 1 =>
            XC := X;
            YC := 15 - Y;
         when 2 =>
            XC := 15 - Y;
            YC := 15 - X;
         when 3 =>
            XC := 15 - X;
            YC := Y;
         when 4 =>
            XC := Y;
            YC := X;
         when others =>                  -- won't happen
            null;
      end case;
      X := XC;
      Y := YC;
   end Convert_Coos;


--=============================================================================
   procedure Draw_Background is
      Chat_Spaces_1 : String(1               .. Chat_Name_W ) := (others => ' ');
      Chat_Spaces_2 : String(Chat_Name_W + 2 .. Chat_Width-2) := (others => ' ');
   begin
      Set_Graphical_Mode(On);

      -- Draw chess board
      Put(Upper_Left_Corner);
      for I in 1..13 loop
         Put(Horisontal_Line, 3);
         Put(Horisontal_Down);
      end loop;
      Put(Horisontal_Line, 3);
      Put_Line(Upper_Right_Corner);

      for J in 1..13 loop
         for I in 1..14 loop
            Put(Vertical_Line);
            Put("   ");
         end loop;
         Put_Line(Vertical_Line);

         Put(Vertical_Right);
         for I in 1..13 loop
            Put(Horisontal_Line, 3);
            Put(Cross);
         end loop;
         Put(Horisontal_Line, 3);
         Put_Line(Vertical_Left);
      end loop;

      for I in 1..14 loop
         Put(Vertical_Line);
         Put("   ");
      end loop;
      Put_Line(Vertical_Line);

      Put(Lower_Left_Corner);
      for I in 1..13 loop
         Put(Horisontal_Line, 3);
         Put(Horisontal_Up);
      end loop;
      Put(Horisontal_Line, 3);
      Put_Line(Lower_Right_Corner);

      -- Draw chat area
      Goto_XY(Chat_Offset, 1);
      Put(Upper_Left_Corner);
      Put(Horisontal_Line, Chat_Name_W);
      Put(Horisontal_Down);
      Put(Horisontal_Line, Chat_Width - Chat_Name_W - 3);
      Put(Upper_Right_Corner);
      for I in 1..Chat_Lines loop
         Goto_XY(Chat_Offset, 1+I);
         Put(Vertical_Line);
         Put(Chat_Spaces_1);
         Put(Vertical_Line);
         Put(Chat_Spaces_2);
         Put(Vertical_Line);
      end loop;
      Goto_XY(Chat_Offset, Chat_Lines+2);
      Put(Vertical_Right);
      Put(Horisontal_Line, Chat_Width-2);
      Put(Vertical_Left);
      Goto_XY(Chat_Offset, Chat_Lines+3);
      Put(Vertical_Line);
      Put(Chat_Spaces_1);
      Put(Vertical_Line);
      Put(Chat_Spaces_2);
      Put(Vertical_Line);
      Goto_XY(Chat_Offset, Chat_Lines+4);
      Put(Lower_Left_Corner);
      Put(Horisontal_Line, Chat_Width-2);
      Put(Lower_Right_Corner);

      Goto_XY(Chat_Offset+20, Chat_Lines+2);
      Put(Cross);
      Goto_XY(Chat_Offset+20, Chat_Lines+3);
      Put(Vertical_Line);
      Goto_XY(Chat_Offset+20, Chat_Lines+4);
      Put(Horisontal_Up);

      Set_Graphical_Mode(Off);

   end Draw_Background;


--=============================================================================
   procedure Draw_Man(X, Y : in Positive; Bold_Flag : in Boolean := False) is
      Man, Mat_No : Natural := 0;
      XC, YC : Integer;
   begin
      XC := X;
      YC := Y;
      Convert_Coos(XC, YC);
      for I in 1..4 loop
         Man := Planen(I)(XC)(YC);
--           case Player_ID is
--              when 1 =>
--                 Man := Planen(I)(X)(15-Y);
--              when 2 =>
--                 Man := Planen(I)(15-Y)(15-X);
--              when 3 =>
--                 Man := Planen(I)(15-X)(Y);
--              when 4 =>
--                 Man := Planen(I)(Y)(X);
--              when others =>                  -- won't happen
--                 null;
--           end case;
         if Man /= 0 then
            Mat_No := I;
            exit;
         end if;
      end loop;
      Goto_XY(4*X - 1, 2*Y);
      Set_Foreground_Colour(Colour_LUT(Mat_No));
      if Bold_Flag then
         Set_Bold_Mode(On);
      end if;
      Put(Man_LUT(Man));
      Set_Bold_Mode(Off);

   end Draw_Man;


--=============================================================================
   procedure Draw_All_Men is
   begin
      for Y in 1..14 loop
         for X in 1..14 loop
            Draw_Man(X, Y);
         end loop;
      end loop;

      Reset_Colours;
      Restore_Cursor;

   end Draw_All_Men;


--=============================================================================
   procedure Draw_Chat_Bottom is
   begin
      Goto_XY(Chat_Offset+1, 1+Chat_Lines+2);
      Set_Foreground_Colour(White);
      Put("TILL: ");
      Set_Foreground_Colour(Colour_LUT(Chat_To_ID));
      if Chat_To_ID = 0 then
         Put("*ALLA*      ");
      else
         Put(Name_Arr(Chat_To_ID).Str);
      end if;

      -- Skriv ut temp-chatsträng längst ner
      Goto_XY(Chat_Offset+1 + Chat_Name_W+1, Chat_Lines + 3);
      Set_Foreground_Colour(Colour_LUT(Player_ID));
      Put(Chat_Str);

      Restore_Cursor;

   end Draw_Chat_Bottom;


--=============================================================================
   procedure Draw_Chat is
   begin
      for I in 1..Chat_Lines loop
         if Chat_History(I).Player_ID /= 0 then
            Goto_XY(Chat_Offset+1, 1+I);
            Set_Foreground_Colour(Colour_LUT(Chat_History(I).Player_ID));
            Put(Name_Arr(Chat_History(I).Player_ID).Str);
            Goto_XY(Chat_Offset+1 + Name_Arr(Chat_History(I).Player_ID).Str_Len, 1+I);
            if Chat_History(I).Private_Flag then
               Put("(*)");
            end if;
            Put(':');
            Goto_XY(Chat_Offset+1 + Chat_Name_W+1, 1+I);
            Put(Chat_History(I).Mess);
         end if;
      end loop;

      Draw_Chat_Bottom;

   end Draw_Chat;


--=============================================================================
   procedure Draw_Status_String(Player : in Natural; Str : in String; Y : in Natural) is
   begin
      if Player = 0 then
         Goto_XY( 2, Status_Y + Y );
      else
         Goto_XY( Status_Offset +
                  (Player-1) * Status_Width +
                  (Status_Width-Str'Length+1) / 2,
                  Status_Y + Y);
      end if;
      Set_Foreground_Colour( Colour_LUT(Player) );
      Put(Str);
      Put("  ");
   end Draw_Status_String;


--=============================================================================
   procedure Draw_Status is
      Clr_Str : String(1 .. 5*Status_Width) := (others => ' ');
   begin
      -- Clear stuff that tends to update, in case the screen isn't cleared
      -- just before this procedure is called...
      Set_Foreground_Colour(White);
      Goto_XY(Status_Offset, Status_Y + 2);
      Put(Clr_Str);
      Goto_XY(Status_Offset, Status_Y + 3);
      Put(Clr_Str);

      Draw_Status_String(0, "Namn:", 0);
      Draw_Status_String(0, "Hitpoints:", 2);
      Draw_Status_String(0, "Kungadråp:",   3);
      for I in 1..4 loop
         if I = Player_ID then
            Set_Bold_Mode(On);
         end if;
         Draw_Status_String(I, Name_Arr(I).Str(1..Name_Arr(I).Str_Len), 0);
         Set_Bold_Mode(Off);
         Draw_Status_String(I, Integer'Image(Kills(I)),                 2);
         Draw_Status_String(I, Integer'Image(Kills(4+I)),               3);
      end loop;

      Draw_Status_String(5, "Vinstkrav",                  0);
      Draw_Status_String(5, Integer'Image(Game_Rec.Pts),  2);
      Draw_Status_String(5, Integer'Image(Game_Rec.Kill), 3);

      Restore_Cursor;

   end Draw_Status;


--=============================================================================
   -- Message print proc
   procedure Draw_Mess(Str : in String) is
      Clr_Str : String(1..70) := (others => ' ');
      Bold_Save : Bold_Mode_Type;
   begin
      Bold_Save := Get_Bold_Mode;
      Goto_XY(Status_Offset + 5*Status_Width + 10, Status_Y + 1);
      Set_Bold_Mode(Off);
      Put(Clr_Str);
      Goto_XY(Status_Offset + 5*Status_Width + 10, Status_Y + 1);
      Set_Bold_Mode(On);
      Set_Foreground_Colour(Cyan);
      Put("> " & Str);
      Reset_Colours;
      Set_Bold_Mode(Bold_Save);
      Restore_Cursor;
   end Draw_Mess;


--=============================================================================
   procedure Clear_Mess is
      Clr_Str : String(1..70) := (others => ' ');
      Bold_Save : Bold_Mode_Type;
   begin
      Bold_Save := Get_Bold_Mode;
      Set_Bold_Mode(Off);
      Goto_XY(Status_Offset + 5*Status_Width + 10, Status_Y + 1);
      Put(Clr_Str);
      Reset_Colours;
      Set_Bold_Mode(Bold_Save);
      Restore_Cursor;
   end Clear_Mess;


--=============================================================================
   procedure Draw_Turn is
   begin
      if Player_To_Move = Player_ID then
         Draw_Mess("Ditt drag!");
      else
         -- Petty stuff: no 's' after a name that ends with an 's'
         if Name_Arr(Player_To_Move).Str(Name_Arr(Player_To_Move).Str_Len) = 'S'
           or Name_Arr(Player_To_Move).Str(Name_Arr(Player_To_Move).Str_Len) = 's' then
            Draw_Mess(Name_Arr(Player_To_Move).Str(1..Name_Arr(Player_To_Move).Str_Len) &
                      " drag...");
         else
            Draw_Mess(Name_Arr(Player_To_Move).Str(1..Name_Arr(Player_To_Move).Str_Len) &
                      "s drag...");
         end if;
      end if;

   end Draw_Turn;


--=============================================================================
   procedure Draw_Time(In_Time : in Integer; Colour : in Colour_Type := White) is
      Echo_Save : Echo_Mode_Type;
   begin
      Echo_Save := Get_Echo_Mode;
      Set_Echo_Mode(Off);

      Goto_XY(Status_Offset + 5*Status_Width + 12, Status_Y + 3);
      Set_Foreground_Colour(Colour);
      if In_Time < 0 or Player_To_Move /= Player_ID then
         Put("             ");
      else
         Put("Time: ");
         Put(In_Time, Width => 0);
         Put("    ");
      end if;

      Set_Echo_Mode(Echo_Save);

   end Draw_Time;


--=============================================================================
   procedure Draw_Info is
   begin
      Set_Foreground_Colour(Blue);
      Goto_XY(1, Status_Y + 6);
      Put_Line(" Så här rattar du:");
      New_Line;
      Put_Line(" Tangent        Spelläge            Chatläge");
      Put_Line(" =======        ========            ========");
      Put_Line(" Piltangenter   Styr markör         Välj mottagare (upp/ner)");
      Put_Line(" Return         Välj ruta           Skicka inmatat meddelande");
      Put_Line(" Tab            Byt till chatläge   Byt till spelläge");
      Put_Line(" Esc            Avbryt draget       Rensa inmatat meddelande");
   end Draw_Info;


--=============================================================================
   procedure Gfx_Draw_All is
   begin
      Clear_Window;
      Reset_Colours;

      Draw_Background;
      Draw_All_Men;
      Draw_Chat;
      Draw_Status;
      Draw_Turn;
      Draw_Time(Game_Rec.Tid);
      Draw_Info;

   end Gfx_Draw_All;


--=============================================================================
   function Get_Drag_Rec(X1, Y1, X2, Y2 : in Positive) return Drag_Record is
      D_Rec : Drag_Record;
      X1C : Integer := X1;
      Y1C : Integer := Y1;
      X2C : Integer := X2;
      Y2C : Integer := Y2;
   begin
      Convert_Coos(X1C, Y1C);
      Convert_Coos(X2C, Y2C);
      D_Rec.Piece  := Get_Piece(X1C, Y1C);
      D_Rec.In_X   := X1C;
      D_Rec.In_Y   := Y1C;
      D_Rec.End_X  := X2C;
      D_Rec.End_Y  := Y2C;
      D_Rec.Slag   := Get_Piece(D_Rec.End_X, D_rec.End_Y);
      return D_Rec;
   end Get_Drag_Rec;


--=============================================================================
   procedure Gfx_Move(Drag : Drag_Record) is
      X1, Y1, X2, Y2 : Natural;
      Echo_Save : Echo_Mode_Type;
--      Slask_Chr : Character;
   begin
      Echo_Save := Get_Echo_Mode;
      Set_Echo_Mode(Off);

--      Draw_Mess("Nu är vi i Gfx_Move, anropad från Gfx_Send_Move!");

      X1 := Drag.In_X;
      Y1 := Drag.In_Y;
      X2 := Drag.End_X;
      Y2 := Drag.End_Y;
      Convert_Coos(X1, Y1);
      Convert_Coos(X2, Y2);

--        New_Line;
--        Put("Drag! Spelare: ");
--        Put(Drag.Player, Width => 0);
--        Put("  Skärmkoordinater: ");
--        Put(X1, Width => 3);
--        Put(Y1, Width => 3);
--        Put(X2, Width => 3);
--        Put(Y2, Width => 3);
--        New_Line;
--        Get_Immediate(Slask_Chr);

      -- Put cursor at the "move from" square and wait a while
      Goto_XY(4*X1 - 1, 2*Y1);
      delay(1.0);
      Set_Foreground_Colour(White);
      Put(' ');
      -- Put cursor at the "move to" square, draw the man and wait a while
      Goto_XY(4*X2 - 1, 2*Y2);
      Set_Foreground_Colour(Colour_LUT(Drag.Player));
      Put(Man_LUT(Drag.Piece));
      Goto_XY(4*X2 - 1, 2*Y2);
      delay(0.7);

--      Chess_Pack.Move(Drag);  -- detta ska utföras från klienten!

      Draw_Status;

      Restore_Cursor;

      Set_Echo_Mode(Echo_Save);

   end Gfx_Move;


--=============================================================================
   -- Global ogly bogly version!!!
   procedure Gfx_Init is
   begin
      Gfx_Init(Game_Rec.Me, Game_Rec.Namn);
   end Gfx_Init;


--=============================================================================
   procedure Gfx_Init(In_Player_ID : in Positive; In_Name_Arr : in Name_Arr_Type) is
   begin
      Set_Echo_Mode(Off);

      Player_ID := In_Player_ID;
      Name_Arr  := In_Name_Arr;

      Player_To_Move := 1;  -- player 1 always starts

      Play_Mode := Game_E;
      Move_Mode := From_E;

      Cursor_X := 7;
      Cursor_Y := 13;
      Cursor_Chat := 1;

      Chat_History := (others => (0, False, (others => ' ')));
      Chat_Str     := (others => ' ');
      Chat_To_ID   := 0;

      From_X       := 0;  -- zero when no square is selected
      From_Y       := 0;

      Set_Default_Colours(White, Black);
      Reset_Colours;

      Gfx_Draw_All;
   end Gfx_Init;


--=============================================================================
   procedure Cancel_Move is
   begin
      if From_X /= 0 then
         Draw_Man(From_X, From_Y, False);
         From_X := 0;
         From_Y := 0;
         Clear_Mess;
         Restore_Cursor;
      end if;
   end Cancel_Move;


--=============================================================================
   function  Gfx_Update return String is
      procedure Copy_Str(Dest : out String; Source : in String) is
      begin
         Dest(1..Source'Length) := Source;
      end Copy_Str;

      Num_Str : constant array (1..14) of String(1..2) :=
        ( "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14" );
      Ret_Str  : String(1..Max_Str_Len) := (others => ' ');
      Move_Str : String(1..13);
      Drag     : Drag_Record;

      Key : Key_Type;
      Key_Code : Key_Code_Type;
      XC, YC : Integer;

   begin
      Restore_Cursor;

      loop
         Get_Immediate(Key);

         -- Tydligen ajabaja att försöka konvertera vanliga teckenknappar, så...
         if Is_Character(Key) then
            Key_Code := Key_Undefined;
         else
            Key_Code := To_Key_Code_Type(Key);
         end if;

         case Play_Mode is
            when Game_E =>
               case Key_Code is
                  when Key_Tab =>
                     Cancel_Move;
                     Play_Mode := Chat_E;
                     Restore_Cursor;
                  when Key_Up_Arrow =>
                     if Cursor_Y > 1 then
                        Cursor_Y := Cursor_Y - 1;
                     end if;
                  when Key_Down_Arrow =>
                     if Cursor_Y < 14 then
                        Cursor_Y := Cursor_Y + 1;
                     end if;
                  when Key_Left_Arrow =>
                     if Cursor_X > 1 then
                        Cursor_X := Cursor_X - 1;
                     end if;
                  when Key_Right_Arrow =>
                     if Cursor_X < 14 then
                        Cursor_X := Cursor_X + 1;
                     end if;
                  when Key_Return =>
                     if From_X = 0 then
                        -- Välj ruta att flytta FRÅN
                        XC := Cursor_X;
                        YC := Cursor_Y;
                        Convert_Coos(XC, YC);
                        if Get_Owner(XC, YC) = Player_ID then
                           Draw_Mess("Välj en ruta att flytta till.");
                           From_X := Cursor_X;
                           From_Y := Cursor_Y;
                           Draw_Man(Cursor_X, Cursor_Y, True);
                        end if;
                     else
                        -- Välj ruta att flytta TILL
                        if From_X = Cursor_X and From_Y = Cursor_Y then
                           Cancel_Move;
                           Draw_Mess("Drag avbrutet.");
                        elsif Player_To_Move /= Player_ID then
                           Draw_Mess("Vänta på din tur!");
                        else
                           Move_Str := "00-00-00-00-0";
                           XC := From_X;
                           YC := From_Y;
                           Convert_Coos(XC, YC);
                           Move_Str(13) := Character'Val(Get_Piece(XC, YC) + 48);
                           Move_Str(1..2) := Num_Str(XC);
                           Move_Str(4..5) := Num_Str(YC);
                           XC := Cursor_X;
                           YC := Cursor_Y;
                           Convert_Coos(XC, YC);
                           Move_Str(7..8)   := Num_Str(XC);
                           Move_Str(10..11) := Num_Str(YC);
                           Convert(Move_Str, Drag);
                           Drag.Player := Player_ID;
                           Cont(Drag);   -- fill in the "Legal" boolean
                           if Drag.Legal = False then --or Get_Owner(XC, YC) = Player_ID then
                              Draw_Mess("Ogiltigt drag, försök igen.");
                           else
                              Clear_Mess;
                              From_X := 0;
                              From_Y := 0;
                              Ret_Str(1..5)  := "MOVE ";
                              Ret_Str(6..18) := Move_Str;
                              exit;
                           end if;
                        end if;
                     end if;
                  when Key_Esc =>
                        Cancel_Move;
                        Draw_Mess("Drag avbrutet.");
                  when others =>
                     null;
               end case;

               Restore_Cursor;

            when Chat_E =>
               case Key_Code is
                  when Key_Tab =>
                     Play_Mode := Game_E;
                     Restore_Cursor;
                  when Key_Up_Arrow =>
                     Chat_To_ID := Chat_To_ID + 1;
                     loop
                        if Chat_To_ID > 4 then
                           Chat_To_ID := 0;
                        end if;
                        exit when Chat_To_ID /= Player_ID;
                        Chat_To_ID := Chat_To_ID + 1;
                     end loop;
                     Draw_Chat_Bottom;
                  when Key_Down_Arrow =>
                     Chat_To_ID := Chat_To_ID - 1;
                     loop
                        if Chat_To_ID < 0 then
                           Chat_To_ID := 4;
                        end if;
                        exit when Chat_To_ID /= Player_ID;
                        Chat_To_ID := Chat_To_ID - 1;
                     end loop;
                     Draw_Chat_Bottom;
                  when Key_Return =>
                     if Cursor_Chat > 1 then
                        Ret_Str(1..5) := "CHAT ";
                        Ret_Str(6) := Character'Val(48+Player_ID);
                        if Chat_To_ID = 0 then
                           Ret_Str(7) := 'A';
                        else
                           Ret_Str(7) := Character'Val(48+Chat_To_ID);
                        end if;
                        Ret_Str(8 .. Cursor_Chat+6) := Chat_Str(1 .. Cursor_Chat-1);
                        Cursor_Chat := 1;
                        Chat_Str := (others => ' ');
                        Draw_Chat_Bottom;
                        exit;
                     end if;
                  when Key_Backspace =>
                     if Cursor_Chat > 1 then
                        Cursor_Chat := Cursor_Chat - 1;
                        Chat_Str(Cursor_Chat) := ' ';
                        Restore_Cursor;
                        Put(' ');
                        Restore_Cursor;
                     end if;
                  when Key_Esc =>
                     Cursor_Chat := 1;
                     Chat_Str := (others => ' ');
                     Draw_Chat_Bottom;
                  when others =>
                     null;
                     if Is_Character(Key) then
                        if Cursor_Chat < Chat_Str_Max then
                           Put(Key);
                           Chat_Str(Cursor_Chat) := To_Character(Key);
                           Cursor_Chat := Cursor_Chat + 1;
                        end if;
                     end if;
               end case;

         end case;

      end loop;

--      Copy_Str(Ret_Str, "CHAT 1AMess till alla.");
      return Ret_Str;

   end Gfx_Update;


--=============================================================================
   procedure Gfx_Send_Move(Drag : Drag_Record) is
--      Str  : String(1..13);
   begin
--      Str(Str'Range) := In_Str;   -- must be range 1..13
--      Convert(Str, Drag);
--      Drag.Player := Player_To_Move;


      case Drag.Piece is
         when 1..6 =>
            Gfx_Move(Drag);
         when 8 =>
            if Drag.Player = Player_ID then
               for I in 1..8 loop
                  Draw_Mess("Jäklars, slut på tid!");
                  delay 0.3;
                  Clear_Mess;
                  delay 0.2;
               end loop;
            end if;
         when others =>
            null;
      end case;

      Draw_All_Men;

      -- Evighetsloop om alla är döda, så se till att inte
      -- anropa när spelet är slut...
      if not (Alive(1) or Alive(2) or Alive(3) or Alive(4)) then
         delay 10.0;
      else
         loop
            Player_To_Move := 1 + (Player_To_Move mod 4);
            exit when Alive(Player_To_Move);
         end loop;
      end if;

      Draw_Turn;

   end Gfx_Send_Move;


--=============================================================================
   procedure Gfx_Send_Chat(In_Str : in String) is
      Chat_Len : Natural := In_Str'Length - 2;
      Mess_Len : Natural := Chat_History(1).Mess'Length;
   begin
      -- Shift chat history one line up
      for I in 1..Chat_Lines-1 loop
         Chat_History(I) := Chat_History(I+1);
      end loop;

      -- Add the new line
      Chat_History(Chat_Lines).Player_ID := Integer'Value(In_Str(In_Str'First .. In_Str'First));
      if In_Str(In_Str'First + 1) = 'A' then
         Chat_History(Chat_Lines).Private_Flag := False;
      else
         Chat_History(Chat_Lines).Private_Flag := True;
      end if;
      Chat_History(Chat_Lines).Mess := (others => ' ');

      -- Crop the message if it is too long
      if Chat_Len > Mess_Len then
         Chat_History(Chat_Lines).Mess :=
           In_Str(In_Str'First + 2 .. In_Str'First + 2 + Mess_Len-1);
      else
         Chat_History(Chat_Lines).Mess(1 .. Chat_Len) :=
           In_Str(In_Str'First + 2 .. In_Str'Last);
      end if;

      Draw_Chat;

--      Draw_Mess("Nu har vi gått igenom Gfx_Send_Chat!");

   end Gfx_Send_Chat;


--=============================================================================
   procedure Gfx_Send_Time(In_Time : in Integer) is
   begin
      if In_Time < 11 and In_Time >= 0 then
         Beep;
         Draw_Time(In_Time, Red);
         delay 0.15;
      end if;
      Draw_Time(In_Time);
      Restore_Cursor;

   end Gfx_Send_Time;


--=============================================================================
   procedure Gfx_Send_Win(Win_Mode : in Win_Mode_Type; Player_Won : Positive) is
      Str : String(1..57) := (others => ' ');
      Offs : Integer;
      type Frame is array(1..8) of String(1..29);
      type Film is array(1..19) of Frame;

      Ascii_Film : Film := ((
"                             ",
"                             ",
"  O              O           ",
" /|\\/        \\/|\\         ",
" ||              |           ",
" /|             |\\          ",
"/ |             | \\         ",
"` `             ' '          "
                               ),(
"                             ",
"                             ",
"    O         O              ",
"   /|         |\             ",
"  / \\       // \            ",
" /|             |\\          ",
"/ |             | \\         ",
"` `             ' '          "
                                ),(
"                             ",
"                             ",
"                             ",
"                             ",
"  ____O     O____            ",
" /|  \\/    \\/ |\           ",
"/ |             | \          ",
"` `             ' '          "
                                ),(
"                             ",
"                             ",
"                             ",
"                             ",
"  ____O     O____            ",
" /|  \\/    \\/ |\           ",
"/ |             | \          ",
"` `             ' '          "
                                   ),(

"                             ",
"                             ",
"    O         O              ",
"   /|         |\             ",
"  / \\       // \            ",
" /|             |\           ",
"/ |             | \          ",
"` `             ' '          "
                                      ),(
"                             ",
"                             ",
"  O             O            ",
" /|\\/       \\/|\\          ",
" ||             |            ",
" /|             |\           ",
"/ |             | \          ",
"` `             ' '          "
                                         ),(
"                             ",
"                             ",
"   __O                       ",
"  / /\\/         O           ",
"   /          \\/|\\_        ",
"__/\\            |           ",
"   /            <<           ",
"   `            ''           "
                                            ),(
"                             ",
"                             ",
"     __O         O           ",
"    / /\\/    \\/|\\         ",
"     /           |           ",
"    /\\         //           ",
"   / /         \\\           ",
"   ` `          ''           "
                                               ),(
"                             ",
"               O             ",
"       O    \\/|\\_          ",
"      //\\/  __|             ",
"       |   /   |             ",
"      /\\  '   \\            ",
"     /  \\     '             ",
"     `   `                   "
                                                  ),(
"              O              ",
"           \\/|\\_           ",
"        O*___ |              ",
"       /\\/   /              ",
"       \\|    \\             ",
"        |\\   '              ",
"        | \\                 ",
"        `  `                 "
                                                     ),(
"             O               ",
"          \\/|\\             ",
"       O*____| \             ",
"       /\\_/ /               ",
"      \\ \\  \\              ",
"         /\\ '               ",
"        /  \\                ",
"        `   `                "
                                                        ),(
"                             ",
"           O                 ",
"        \\/|\\               ",
"     O*  __| \               ",
"    / `./  \\                ",
"    \\  `._ \\               ",
"         > / `               ",
"        `  `                 "
                                                           ),(
"                             ",
"                             ",
"           O                 ",
"          /|\\               ",
"         / |/                ",
"   O*     /\\                ",
"  //\\__ \\ \\               ",
"  \\\\ \\___,                "
                                                              ),(
"                             ",
"                             ",
"                             ",
"          O                  ",
"       __/|\\                ",
"          |  \               ",
" *O*     //\\                ",
" <<\\____\\_\\               "
                                                                 ),(
"                             ",
"                             ",
"                             ",
"      \\__O                  ",
"          |\\/               ",
"          |                  ",
"?\\      //\\                ",
"O/___/\\_\\_\\               "
                                                                    ),(
"              ,-----------.  ",
"             ( Yeah! I win ) ",
"       \   ,' `-----------'  ",
"        \\O__/               ",
"          |                  ",
"          |                  ",
"?        //\\                ",
"O__/_/\\_\\_\\               "
                                                                       ),(
"              ,-----------.  ",
"            ,( Yeah! I win ) ",
"       \   ,/ `-----------'  ",
"        \\O/                 ",
"          |                  ",
"          |                  ",
"?        //\\                ",
"O__/_/\\_\\_\\               "
                                                                          ),(
"              ,-----------.  ",
"            ,( Yeah! I win ) ",
"       \   ,/ `-----------'  ",
"        \\O/                 ",
"          |                  ",
"          |                  ",
"?        //\\                ",
"O__/_/\\_\\_\\               "
                                                                             ),(
"              ,-----------.  ",
"            ,( Yeah! I win ) ",
"       \   ,/ `-----------'  ",
"        \\O/                 ",
"          |                  ",
"          |                  ",
"?        //\\                ",
"O__/_/\\_\\_\\               "
                                                                                ));

      type Frame2 is array(1..3) of String(1..15);
      type Film2 is array(1..11) of Frame2;

      Ascii_Film2 : Film2 :=


        ((
        "  o            ",
        " /|\           ",
        " / \           "),(

        " \o/           ",
        "  |            ",
        " / \           "),(

        "  _ o          ",
        "   /\          ",
        "  | \          "),(

        "               ",
        "     __\o      ",
        "    /)  |      "),(

        "     __|       ",
        "       \o      ",
        "       ( \     "),(

        "       \ /     ",
        "        |      ",
        "       /o\     "),(

        "          |__  ",
        "        o/     ",
        "       / )     "),(

        "               ",
        "        o/__   ",
        "        |  (\  "),(

        "            o _",
        "           /\  ",
        "           / | "),(

        "            \o/",
        "             | ",
        "            / \"),(

        "             o ",
        "            /|\",
        "            / \"));


   begin
      if Player_Won = Player_ID then
         Offs := 20;
         Str(1 .. Offs) := "Du har vunnit genom ";
      else
         Offs := Name_Arr(Player_Won).Str_Len + 18;
         Str(1 .. Offs) :=
           Name_Arr(Player_Won).Str(1..Name_Arr(Player_Won).Str_Len) & " har vunnit genom ";
      end if;

      case Win_Mode is
         when Regicide =>
            Str(Offs+1 .. Offs+11) := "regicid !!!";
         when Genocide =>
            Str(Offs+1 .. Offs+9)  := "genocid !";
         when Last_Man_Standing =>
            Str(Offs+1 .. Offs+27) := "att vara sist kvar på plan.";
         when others =>
            null;
      end case;
      for T in 1..5 loop
         if Player_Won = Player_ID then
            Set_Foreground_Colour(Colour_LUT(Player_ID));
            Draw_Mess(Str);
            for I in 1..19 loop
               for K in 1..8 loop
                  Goto_XY(110, 35+K);
                  Put(Ascii_Film(I)(K));
               end loop;
               Restore_Cursor;
               delay 0.2;
            end loop;
         else
            Set_Foreground_Colour(Colour_LUT(Player_ID));
            Goto_XY(104, 34);
            Put("Ni har just fått smisk av " &
                Game_Rec.Namn(Player_Won).Str(1..Game_Rec.Namn(Player_Won).Str_Len) & "!!");
            Draw_Mess(Str);
            for I in 1..11 loop
               for K in 1..3 loop
                  Goto_XY(100, 35+K);
                  Put(Ascii_Film2(I)(K));
               end loop;
               Restore_Cursor;
               delay 0.15;
            end loop;
            for I in reverse 1..11 loop
               Set_Foreground_Colour(Colour_LUT(Player_ID));
               Goto_XY(100, 34);
               for K in 1..3 loop
                  Goto_XY(100, 35+K);
                  Put(Ascii_Film2(I)(K));
               end loop;
               Restore_Cursor;
               delay 0.13;
            end loop;
         end if;
      end loop;

   end Gfx_Send_Win;


--=============================================================================
   procedure Gfx_Exit is
   begin
      Set_Echo_Mode(On);

      Reset_To_Original_Window_Settings;
   end Gfx_Exit;
 --=============================================================================
   Procedure Gfx_Intro is
      Slask_Johan : Character;
   begin
      Set_Graphical_Mode(On);
      Goto_Xy(5,5);
      Put(Upper_Left_Corner,1);
      Put(Horisontal_Line,60);
      Put_Line(Upper_Right_Corner,1);
      for I in 1..40 loop
         Goto_Xy(5,5+I);
         Put(Vertical_Line,1);
         Goto_Xy(60+5,5+I);
         Put(Vertical_Line,1);
      end loop;
      Goto_Xy(5,50);
      Put(Lower_Left_Corner,1);
      Put(Horisontal_Line,60);
      Put(Lower_Right_Corner,1);
      Set_Graphical_Mode(Off);
      Get_Immediate(Slask_Johan);
   end Gfx_Intro;


end Gfx_Pack;
