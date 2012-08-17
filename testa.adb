with Ada.Text_Io;          use Ada.Text_Io;
with Chess_Pack;           use Chess_Pack;
with Rule_Pack;            use Rule_Pack;
with Ada.Integer_Text_Io;  use Ada.Integer_Text_IO;


procedure Testa is


   Game_Rec : Game_Rec_Type;


begin

   Get_Data(Game_Rec);
   Put(Game_Rec.Tid);
   New_Line;
   Put_Line(Game_Rec.Tid_Str);
   Put(Game_Rec.Kill);
   New_Line;
   Put_Line(Game_Rec.Kill_Str);
   Put(Game_Rec.Pts);
   New_Line;
   Put_Line(Game_Rec.Pts_Str);

end Testa;
