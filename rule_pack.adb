with Ada.text_iO;                       use Ada.text_iO;
with Ada.Integer_text_iO;       use Ada.Integer_text_iO;


package body Rule_Pack is

procedure Bonde(Move : in out Drag_Record) is

begin
   Move.Legal := False;
   case Move.Player is
      when 1 =>
            if Move.End_Y = 14 then
               Move.Piece := 5;
            end if;
      when 2 =>
            if Move.End_X = 14 then
               Move.Piece := 5;
            end if;
      when 3 =>
            if Move.End_Y = 1 then
               Move.Piece := 5;
            end if;
      when 4 =>
            if Move.End_X = 1 then
               Move.Piece := 5;
            end if;
      when others =>
         null;

   end case;


   if Move.Slag = 0 and (abs(Move.In_X - Move.End_X) +
                         abs(Move.In_Y - Move.End_Y)) = 1 then
      case Move.Player is
         when 1 =>
            if Move.In_Y - Move.End_Y = -1 then
               Move.Legal := True;
            end if;
         when 2 =>
            if Move.In_X - Move.End_X = -1 then
               Move.Legal := True;
            end if;
         when 3 =>
            if Move.In_Y - Move.End_Y = 1 then
               Move.Legal := True;
            end if;
         when 4 =>
            if Move.In_X - Move.End_X = 1 then
               Move.Legal := True;
            end if;
         when others =>
            null;

      end case;

   elsif Move.Slag = 0 and ((abs(Move.In_X - Move.End_X) = 2 and Move.In_Y = Move.End_Y) or
                            (abs(Move.In_Y - Move.End_Y) = 2 and Move.In_X = Move.End_X )) then
                case Move.Player is
                   when 1 =>
                      if Move.In_Y = 2 and Move.End_Y = 4 and (Get_Piece(Move.In_X, 3) = 0) then
                         Move.Legal := True;
                      end if;
                   when 2 =>
                      if Move.In_X = 2 and Move.End_X = 4 and (Get_Piece(3, Move.In_Y) = 0) then
                         Move.Legal := True;
                      end if;
                   when 3 =>
                      if Move.In_Y = 13 and Move.End_Y = 11  and (Get_Piece(Move.In_X, 12) = 0)then
                         Move.Legal := True;
                      end if;
                   when 4 =>
                        if Move.In_X = 13 and Move.End_X = 11 and (Get_Piece(12, Move.In_Y) = 0) then
                           Move.Legal := True;
                        end if;
                when others =>
                   null;
                end case;

   elsif not (Move.Slag = 0) and    (abs(Move.In_Y - Move.End_Y) = 1) and
              (abs(Move.In_X - Move.End_X) = 1) then
      case Move.Player is
         when 1 =>
            if Move.In_Y - Move.End_Y = -1 then
               Move.Legal := True;
            end if;
         when 2 =>
            if Move.In_X - Move.End_X = -1 then
               Move.Legal := True;
            end if;
         when 3 =>
            if Move.In_Y - Move.End_Y = 1 then
               Move.Legal := True;
            end if;
         when 4 =>
            if Move.In_X - Move.End_X = 1 then
               Move.Legal := True;
            end if;
         when others =>
            null;
      end case;
   end if;

End Bonde;



procedure Torn(Move : in out Drag_Record) is

   Start : Natural;
   Stop  : Natural;

begin
   Move.Legal := False;
   if move.In_X = Move.End_X then
      if abs(move.In_Y - Move.End_Y) = 1 then
         Move.Legal := True;
         return;
      elsif move.In_Y > Move.End_Y then
         Start := Move.End_Y + 1;
         Stop  := move.In_Y - 1;
      else
         Stop  := Move.End_Y - 1;
         Start := move.In_Y + 1;
      end if;
      for I in Start..Stop loop
         if not (Get_Piece(move.In_X, I) = 0) then
            Move.Legal := False;
            return;
         end if;
      end loop;
    Move.Legal := True;
    return;

   elsif move.In_Y = Move.End_Y then
      if abs(move.In_X - Move.End_X) = 1 then
         Move.Legal := True;
         return;
      elsif move.In_X > Move.End_X then
         Start := Move.End_X + 1;
         Stop  := Move.In_X - 1;
      else
         Stop  := Move.End_X - 1;
         Start := move.In_X + 1;
      end if;
      for I in Start..Stop loop
         if not (Get_Piece(I, Move.In_Y) = 0) then
            Move.Legal := False;
            return;
         end if;
      end loop;
      Move.Legal := True;
      return;

   else
      Move.Legal := False;
   end if;

end Torn;


procedure Horse(Move : in out Drag_Record) is

begin
   Move.Legal := False;
   if abs(Move.In_X - Move.End_X) = 1 then
      if abs(Move.In_Y - Move.End_Y) = 2 then
         Move.Legal := True;
         return;
      end if;
   elsif abs(Move.In_X - Move.End_X) = 2 then
      if abs(Move.In_Y - Move.End_Y) = 1 then
         Move.Legal := True;
         return;
      end if;
   else
      Move.Legal := False;
   end if;
end Horse;


procedure Lopare(Move : in out Drag_Record) is

   Diff : Integer;

begin
   Move.Legal := False;
   Diff := Move.In_X - Move.End_X;
   if Move.In_X - Move.End_X = Move.In_Y - Move.End_Y then
      if Diff < -1 then
         for I in Diff + 1..-1 loop
            if not (Get_Piece(Move.In_X - I, Move.In_Y - I) = 0) then
               Move.Legal := False;
               return;
            end if;
         end loop;

      elsif diff > 1 then
         for I in 1..Diff-1 loop
            if not (Get_Piece(Move.In_X - I, Move.In_Y - I) = 0) then
               Move.Legal := False;
               return;
            end if;
         end loop;

      end if;
      Move.Legal := True;
      return;

   elsif (Move.In_X - Move.End_X) = (Move.End_Y - Move.In_Y) then
      if Diff < -1 then
         for I in (Diff + 1)..-1 loop
            if not (Get_Piece(Move.In_X - I, Move.In_Y + I) = 0) then
               Move.Legal := False;
               return;
            end if;
         end loop;

      elsif diff > 1 then
         for I in 1..(Diff-1) loop
            if not (Get_Piece(Move.In_X - I, Move.In_Y + I) = 0) then
               Move.Legal := False;
               return;
            end if;
         end loop;

      end if;
      Move.Legal := True;
      return;

   end if;
   Move.Legal := False;

end Lopare;


procedure Dam(Move : in out Drag_Record) is

   Annat : Drag_Record := Move;

begin
   Move.Legal := False;
   Torn(Annat);
   if Annat.Legal then
      Move.Legal := True;
      return;
   end if;
   Lopare(Annat);
   if Annat.Legal then
      Move.Legal := True;
      return;
   end if;
   Move.Legal := False;

end Dam;


procedure Kung(Move : in out Drag_Record) is

begin
   Move.Legal := False;
   if (abs(Move.In_Y - Move.End_Y) < 2) and
     (abs(Move.In_X - Move.End_X) < 2) then
      Move.Legal := True;
      return;
   elsif (abs(Move.In_Y - Move.End_Y) = 2) or
     (abs(Move.In_X - Move.End_X) = 2) then
      case Move.Player is
         when 1 =>
            if Move.In_X = 8 and Move.In_Y = 1  and Move.End_Y = 1 then
               if (Move.End_X = 6) and Get_Piece(4, 1) = 2 and Get_Owner(4, 1) = Move.Player
                 and (Get_Piece(5, 1) = 0) and (Get_Piece(6, 1) = 0) and (Get_Piece(7, 1) = 0) then
                  Move.Piece := 7;
                  Move.Legal := True;
                  return;
               elsif Move.End_X = 10 and Get_Piece(11, 1) = 2 and Get_Owner(11, 1) = Move.Player
                 and Get_Piece(9, 1) = 0 and Get_Piece(10, 1) = 0 then
                  Move.Piece := 7;
                  Move.Legal := True;
                  return;
               end if;
            end if;

         when 2 =>
            if Move.In_X = 1 and Move.In_Y = 7 and Move.End_X = 1 then
               if (Move.End_Y = 9) and Get_Piece(1, 11) = 2 and Get_Owner(1, 11) = Move.Player
                 and (Get_Piece(1, 10) = 0) and (Get_Piece(1, 9) = 0) and (Get_Piece(1, 8) = 0) then
                  Move.Piece := 7;
                  Move.Legal := True;
                  return;
               elsif Move.End_X = 5 and Get_Piece(4, 1) = 2 and Get_Owner(4, 1) = Move.Player
                 and Get_Piece(5, 1) = 0 and Get_Piece(6, 1) = 0 then
                  Move.Piece := 7;
                  Move.Legal := True;
                  return;
               end if;
            end if;


         when 3 =>
            if Move.In_X = 7 and Move.In_Y = 14 and Move.End_Y = 14 then
               if (Move.End_X = 9) and Get_Piece(11, 14) = 2 and Get_Owner(11, 14) = Move.Player
                 and (Get_Piece(10, 14) = 0) and (Get_Piece(9, 14) = 0) and (Get_Piece(8, 14) = 0) then
                  Move.Piece := 7;
                  Move.Legal := True;
                  return;
               elsif Move.End_X = 5 and Get_Piece(4, 14) = 2 and Get_Owner(4, 14) = Move.Player
                 and Get_Piece(5, 14) = 0 and Get_Piece(6, 14) = 0 then
                  Move.Piece := 7;
                  Move.Legal := True;
                  return;
               end if;
            end if;



         when 4 =>
            if Move.In_X = 14 and Move.In_Y = 8 and Move.End_X = 14 then
               if (Move.End_Y = 6) and Get_Piece(14, 4) = 2 and Get_Owner(14, 4) = Move.Player
                 and (Get_Piece(14, 5) = 0) and (Get_Piece(14, 6) = 0) and (Get_Piece(14, 7) = 0) then
                  Move.Piece := 7;
                  Move.Legal := True;
                  return;
               elsif Move.End_X = 10 and Get_Piece(14, 11) = 2 and Get_Owner(14, 11) = Move.Player
                 and Get_Piece(14, 10) = 0 and Get_Piece(14, 9) = 0 then
                  Move.Piece := 7;
                  Move.Legal := True;
                  return;
               end if;
            end if;


         when others =>
            null;
      end Case;

   end if;
   Move.Legal := False;
   return;

end Kung;


procedure Suicide(Move : in out Drag_Record) is

begin
   if Get_Owner(Move.End_X, Move.End_Y) = Move.Player then
      Move.Legal := False;
   end if;
end Suicide;


procedure Cont(Drag : in out Drag_Record) is

begin

   Case Drag.Piece is
      when 1 =>
         Bonde(Drag);
      when 2 =>
         Torn(Drag);
      when 3 =>
         Horse(Drag);
      when 4 =>
         Lopare(Drag);
      when 5 =>
         Dam(Drag);
      when 6 =>
         Kung(Drag);
      when 8 =>
         Drag.Legal := True;
      when others =>
         Drag.Legal := False;
   end case;
   Suicide(Drag);

end Cont;


end Rule_Pack;
