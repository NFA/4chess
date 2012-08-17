

with Ada.text_iO;                       use Ada.text_iO;
with Ada.Integer_text_iO;       use Ada.Integer_text_iO;


package body Chess_Pack is


function Get_Piece(X, Y : in integer) return integer is

begin
   for I in 1..4 loop
      if not (Planen(I)(X)(Y) = 0) then
         return Planen(I)(X)(Y);
      end if;
   end loop;
   return 0;

end Get_Piece;


function Get_Owner(X, Y : in integer) return integer is

begin
   for I in 1..4 loop
      if not (Planen(I)(X)(Y) = 0) then
         return I;
      end if;
   end loop;
   return 0;

end Get_Owner;


procedure Data_Convert(Data : in out Game_Rec_Type) is

begin
   Data.Legal := True;
   for I in reverse 1..5 loop
      if Data.Tid_Str(I) = ' ' then
         null;
      else
         Data.Tid :=  Integer'Value(Data.Tid_Str(1..I));
         exit;
      end if;
      if I = 1 then
         Data.Legal := False;
      end if;
   end loop;
   for I in reverse 1..5 loop
      if Data.Kill_Str(I) = ' ' then
         null;
      else
         Data.Kill :=  Integer'Value(Data.Kill_Str(1..I));
         exit;
      end if;
      if I = 1 then
         Data.Legal := False;
      end if;
   end loop;
   for I in reverse 1..5 loop
      if Data.Pts_Str(I) = ' ' then
         null;
      else
         Data.Pts :=  Integer'Value(Data.Pts_Str(1..I));
         exit;
      end if;
      if I = 1 then
         Data.Legal := False;
      end if;
   end loop;

end Data_Convert;


procedure Get_Data(Data : out Game_Rec_Type) is


begin
   loop
      Data.Tid_Str  := "     ";
      Data.Kill_Str := "     ";
      Data.Pts_Str  := "     ";
      Put_Line("Skriv betänketid i sekunder, välj 0 om ni ska köra utan!");
      Get_Line(Data.Tid_Str, Data.Me);
      if Data.Me = 5 then
         Skip_Line;
      end if;
      Put_Line("Skriv in antal slagna kungar det krävs för vinst(1-3)");
      Get_Line(Data.Kill_Str, Data.Me);
      if Data.Me = 5 then
         Skip_Line;
      end if;
      Put_Line("Skriv in slag poäng summa som krävs för vinst (1-80)");
      Get_Line(Data.Pts_Str, Data.Me);
      if Data.Me = 5 then
         Skip_Line;
      end if;
      begin
         Data_Convert(Data);
         if Data.Legal then
            exit;
         end if;
         Put_Line("Du måste skriva något!");
      exception
         when others =>
            Put_Line("Skriv bara siffror!!");
      end;
   end loop;

end Get_Data;





procedure Move(Move : in Drag_Record) is

begin
   for I in 1..4 loop
      Planen(I)(Move.In_X)(Move.In_Y) := 0;
      Planen(I)(Move.End_X)(Move.End_Y) := 0;
   end loop;
   Planen(Move.Player)(Move.End_X)(Move.End_Y) := Move.Piece;

end Move;


procedure Kill(Move : in Drag_Record) is
        Dead : Integer := 0;
begin
        Dead := Get_Owner(Move.End_X, Move.End_Y);
        for I in Matris_type'range loop
                for J in Matris_type'range loop
                        Planen(Dead)(I)(J) := 0;
                end loop;
        end loop;
        Alive(Dead) := False;
        Kills(4 + Move.Player) := Kills(4 + Move.Player) + 1;

end Kill;



procedure Time_Kill(Move : in Drag_Record) is

   Dead : Integer := Move.Player;

begin
        for I in Matris_type'range loop
                for J in Matris_type'range loop
                        Planen(Dead)(I)(J) := 0;
                end loop;
        end loop;
        Alive(Dead) := False;
        Kills(4 + Move.Player) := Kills(4 + Move.Player) - 1;

end Time_Kill;





procedure Points(Move : in Drag_Record) is

Kp : Integer := 0;

begin

        Case Move.Slag is
                when 0 => Kp := 0;
                when 1 => Kp := 1;
                when 2 => Kp := 5;
                when 3 => Kp := 3;
                when 4 => Kp := 3;
                when 5 => Kp := 9;
                when 6 => Kp := 15;
                when others => Put("Slog rokaden?");
        end case;
        Kills(Move.Player) := Kills(Move.Player) + Kp;

end Points;




procedure Convert(D_Str : in String; D_Rec : out Drag_Record) is

begin
   D_rec.Piece  := Integer'Value(D_Str(13..13));
   D_rec.In_X   := Integer'Value(D_Str(1..2));
   D_rec.In_Y   := Integer'Value(D_Str(4..5));
   D_rec.End_X  := Integer'Value(D_Str(7..8));
   D_rec.End_Y  := Integer'Value(D_Str(10..11));
   D_rec.Slag := Get_Piece(D_Rec.End_X, D_Rec.End_Y);

end Convert;


procedure Str_Mod(D_Str : out String; D_rec : in Drag_Record) is

begin
   D_Str(13..13) := Integer'Image(D_rec.Piece)(2..2);

end Str_Mod;



procedure R_Move(Kung : in Drag_Record) is

R_Drag : Drag_Record;

begin
   case Kung.Player is
      when 1 =>

         if Kung.End_X = 6 then
            R_Drag := (2, 4, 1, 7, 1, 0, 1, True);
         elsif Kung.End_X = 10 then
            R_Drag := (2, 11, 1, 9, 1, 0, 1, True);
         end if;

      when 2 =>
         if (Kung.End_Y = 9) then
            R_Drag := (2, 1, 11, 1, 8, 0, 2, True);
         elsif Kung.End_X = 5  then
            R_Drag := (2, 1, 4, 1, 6, 0, 2, True);
         end if;

      when 3 =>
         if Kung.End_X = 9 then
            R_Drag := (2, 11, 14, 8, 14, 0, 3, True);
         elsif Kung.End_X = 5 then
            R_Drag := (2, 4, 14, 6, 14, 0, 3, True);
         end if;


      when 4 =>
         if Kung.End_Y = 6 then
            R_Drag := (2, 14, 4, 14, 7, 0, 4, True);
         elsif Kung.End_X = 10 then
           R_Drag := (2, 14, 11, 14, 9, 0, 4, True);
         end if;

      when others =>
         null;
   end Case;
   Move(R_Drag);

end R_Move;


procedure Tot_Move(Draget : in out Drag_Record) is

begin
   if Draget.Piece = 7 then
      Draget.Piece := 6;
      Move(Draget);
      R_Move(Draget);
      return;
   elsif Draget.Piece = 8 then
      Time_Kill(Draget);
      return;
   elsif Draget.Slag = 6 then
      Points(Draget);
      Kill(Draget);
      Move(Draget);
   else
      Points(Draget);
      Move(Draget);
   end if;

end Tot_Move;


procedure S_Winner(Player : in Integer; Data : in out Game_Rec_Type; Socks : in Chat_Record) is

   Living : Integer := 0;

begin
   Data.Legal := False;
   for I in 1..4 loop
      if Alive(I) then
        Living := Living + 1;
      end if;
   end loop;
   if  Kills(4 + Player) >= Data.Kill then
      Send_To_All(Socks, "5A" &
                  Data.Namn(Player).Str(1..Data.Namn(Player).Str_Len) &
                  " vinner på regicid!");
      Data.Legal := True;
   elsif Kills(Player) >= Data.Pts then
      Send_To_All(Socks, "5A" &
                  Data.Namn(Player).Str(1..Data.Namn(Player).Str_Len) &
                  " vinner på genocid!!");
      Data.Legal := True;
   elsif Living = 1 then
      for I in 1..4 loop
         if Alive(I) then
            Send_To_All(Socks, "5A" &
                        Data.Namn(I).Str(1..Data.Namn(I).Str_Len) &
                        " är ensam kvar på brädet!");
            Data.Legal := True;
         end if;
      end loop;
   end if;
end S_Winner;



procedure C_Winner(Player : in Integer; Data : in Game_Rec_Type; Mode : out Win_Mode_Type; Winner : out integer) is

   Living : Integer := 0;

begin
   for I in 1..4 loop
      if Alive(I) then
        Living := Living + 1;
      end if;
   end loop;

   if  Kills(4 + Player) >= Data.Kill then
      Mode := Regicide;
      Winner := Player;
      return;

   elsif Kills(Player) >= Data.Pts then
      Mode := Genocide;
      Winner := Player;
      return;

   elsif Living = 1 then
      for I in 1..4 loop
         if Alive(I) then
            Mode := Last_Man_Standing;
            Winner := I;
            return;
         end if;
      end loop;
   end if;
   Mode := None;
   Winner := 0;

end C_Winner;


end Chess_Pack;
