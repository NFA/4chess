with Server;   use Server;


package Chess_Pack is




        Type Y_arr is array (1..14) of integer;
        type Matris_type is array (1..14) of Y_arr;
        type Matris_Arr is array (1..4) of Matris_Type;
        type Dead_Alive is array (1..4) of Boolean;
        type Score_Arr is array (1..8) of Integer;
        type Win_Mode_Type is (None, Regicide, Genocide, Last_Man_Standing);

        type Drag_Record is record
                Piece  : Natural := 0;
                In_X   : Natural := 1;
                In_Y   : Natural := 1;
                End_X  : Natural := 1;
                End_Y  : Natural := 1;
                Slag   : Natural := 0;
                Player : Natural := 0;
                Legal  : Boolean := False;
        end record;

        type Name_Type is
           record
              Player_ID : Natural;
              Str       : String(1..12) := (others => ' ');
              Str_Len   : Natural;
           end record;

        type Name_Arr_Type is array (1..5) of Name_Type;

        type Game_Rec_Type is record
           Namn     : Name_Arr_Type;
           Kill     : Integer;
           Kill_Str : String (1..5) := (others => ' ');
           Pts      : Integer;
           Pts_Str  : String (1..5) := (others => ' ');
           Tid      : Integer;
           Tid_Str  : String (1..5) := (others => ' ');
           Me       : Integer;
           Legal    : Boolean := True;
        end record;



        Game_Rec  : Game_Rec_Type;
        Start_Tid : constant := 30;
        Tid : Integer := Start_Tid;
        Max_Str_Len : constant := 85;
        Alive    : Dead_Alive := (True, True, True, True);
        Kills    : Score_Arr := (others => 0);
        Matris1  : Matris_Type := (     (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (3, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (4, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (5, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (6, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (4, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (3, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));

        Matris2  : Matris_Type := (     (0, 0, 0, 2, 3, 4, 6, 5, 4, 3, 2, 0, 0, 0),
                                        (0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));

        Matris3  : Matris_Type := (     (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 4),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 6),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 5),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 4),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));

        Matris4  : Matris_Type := (     (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        (0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0),
                                        (0, 0, 0, 2, 3, 4, 5, 6, 4, 3, 2, 0, 0, 0));

        Planen   : Matris_Arr := (Matris1, Matris2, Matris3, Matris4);




function Get_Piece(X, Y : in integer) return Integer;
function Get_Owner(X, Y : in integer) return Integer;
procedure Data_Convert(Data : in out Game_Rec_Type);
procedure Get_Data(Data : out Game_Rec_Type);
procedure Move(Move : in Drag_Record);
procedure R_Move(Kung : in Drag_Record);
procedure Convert(D_Str : in String; D_rec : out Drag_Record);
procedure Str_Mod(D_Str : out String; D_rec : in Drag_Record);
procedure Kill(Move : in Drag_Record);
procedure Time_Kill(Move : in Drag_Record);
procedure Points(Move : in Drag_Record);
procedure Tot_Move(Draget : in out Drag_Record);
procedure S_Winner(Player : in Integer; Data : in out Game_Rec_Type; Socks : in Chat_Record);
procedure C_Winner(Player : in Integer; Data : in Game_Rec_Type; Mode : out Win_Mode_Type; Winner : out integer);

end Chess_Pack;
