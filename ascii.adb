with Ada.text_iO;                       use Ada.text_iO;
with Ada.Integer_text_iO;       use Ada.Integer_text_iO;
with TJa.Window;            use TJa.Window;

procedure Kickers is


begin
   loop
      Clear_Window;
      New_Line;
      New_Line;
      Put_Line("  O             O");
      Put_Line("/|\\/         \\/|\");
      Put_Line(" ||             ||");
      Put_Line(" /|             |\");
      Put_Line("/ |             | \");
      Put_Line("` `             ' '");
      delay 0.2;
      Clear_Window;
      New_Line;
      New_Line;
      Put_Line("    O         O  ");
      Put_Line("   /|         |\\  ");
      Put_Line("  / \\        // \ ");
      Put_Line(" /|              |\");
      Put_Line("/ |              | \");
      Put_Line("` `              ' '");
      delay 0.2;
      Clear_Window;
      New_Line;
      New_Line;
      Put_Line("                 ");
      Put_Line("                 ");
      Put_Line("  ____O     O____ ");
      Put_Line(" /|  \\/    \\/ |\");
      Put_Line("/ |             | \");
      Put_Line("` `             ' '");
      delay 0.2;
      Clear_Window;
      New_Line;
      New_Line;
      New_Line;
      New_Line;
      Put_Line("  ____O     O____ ");
      Put_Line(" /|  \\/     \\/|\");
      Put_Line("/ |             | \");
      Put_Line("` `             ' '");
      delay 0.2;
      Clear_Window;
      New_Line;
      New_Line;
      Put_Line("    O         O  ");
      Put_Line("   /|         |\\ ");
      Put_Line("  / \\         / \ ");
      Put_Line(" /|              |\");
      Put_Line("/ |              | \");
      Put_Line("` `              ' '");
      delay 0.2;
      Clear_Window;
      New_Line;
      New_Line;
      Put_Line("  O              O");
      Put_Line(" /|\\/        \\/|\");
      Put_Line(" ||              ||");
      Put_Line(" /|              |\");
      Put_Line("/ |              | \");
      Put_Line("` `              ' '");
      delay 0.2;
      Clear_Window;
      New_Line;
      New_Line;
      Put_Line("   __O           ");
      Put_Line("  / /\\/         O ");
      Put_Line("   /          \\/|\\_");
      Put_Line("__/\\            | ");
      Put_Line("   /            <<");
      Put_Line("   `            ''");
      delay 0.2;
      Clear_Window;
      New_Line;
      New_Line;
      Put_Line("     __O        O ");
      Put_Line("    / /\\/   \\/|\\");
      Put_Line("     /          |/ ");
      Put_Line("    /\\        // ");
      Put_Line("   / /        \\\");
      Put_Line("   ` `         ''");
      delay 0.2;
      Clear_Window;
      New_Line;
      Put_Line("               O");
      Put_Line("       O    \\/|\\ ");
      Put_Line("      //\\/  __| \\");
      Put_Line("       |   /  |  ");
      Put_Line("      /\\  '   \\ ");
      Put_Line("     /  \\     '");
      Put_Line("     `   `     ");
      delay 0.2;
      Clear_Window;
      Put_Line("              O");
      Put_Line("           \\/|\\");
      Put_Line("        O*____|\\ ");
      Put_Line("       /\\/   /   ");
      Put_Line("       \\|    \\   ");
      Put_Line("        |\\   '  ");
      Put_Line("        | \\    ");
      Put_Line("        `  `   ");
      delay 0.2;
      Clear_Window;
      Put_Line("             O ");
      Put_Line("          \\/|\\ ");
      Put_Line("       O*____| \\  ");
      Put_Line("       /\\_ /    ");
      Put_Line("       \\|\ \\    ");
      Put_Line("         /\\ '   ");
      Put_Line("        /  \\   ");
      Put_Line("        `   `  ");
      delay 0.2;
      Clear_Window;
      New_Line;
      Put_Line("           O   ");
      Put_Line("        \\/|\\    ");
      Put_Line("     O*   _| \\   ");
      Put_Line("    / `. /  \\     ");
      Put_Line("    \\  `._ \\   ");
      Put_Line("         > / ` ");
      Put_Line("        `  `   ");
      delay 0.2;
      Clear_Window;
      New_Line;
      New_Line;
      Put_Line("          O      ");
      Put_Line("         /|\\     ");
      Put_Line("        / |/     ");
      Put_Line("  *O*    /\\     ");
      Put_Line("  /\\   \\ \\   ");
      Put_Line("  \\\\/\\_, `   ");
      delay 0.2;
      Clear_Window;
      New_Line;
      New_Line;
      New_Line;
      Put_Line("         O       ");
      Put_Line("      __/|\\      ");
      Put_Line("         | \\    ");
      Put_Line(" *O*    /\\     ");
      Put_Line(" <<\\__\\_\\   ");
      delay 0.2;
      Clear_Window;
      New_Line;
      New_Line;
      New_Line;
      Put_Line("      \\__O       ");
      Put_Line("          |\\/     ");
      Put_Line("          |      ");
      Put_Line("?\\       /\\     ");
      Put_Line("O/___/\\_\\_\\  ");
      delay 0.2;
      Clear_Window;
      Put_Line("             ,-----------.");
      Put_Line("            ( Yeah! I win )");
      Put_Line("       \\  ,' `-----------'");
      Put_Line("        \\O__/    ");
      Put_Line("          |       ");
      Put_Line("          |      ");
      Put_Line("?         /\\     ");
      Put_Line("O__/_/\\_\\_\\   ");
      delay 0.2;
      Clear_Window;
      Put_Line("             ,-----------.");
      Put_Line("            ( Yeah! I win )");
      Put_Line("       \\  ,/ `-----------'");
      Put_Line("        \\O/      ");
      Put_Line("          |       ");
      Put_Line("          |      ");
      Put_Line("?        /\\     ");
      Put_Line("O__/_/\\/_,\\   ");
      delay 0.2;
      Clear_Window;
      Put_Line("             ,-----------.");
      Put_Line("            ( Yeah! I win )");
      Put_Line("       \\  ,/ `-----------'");
      Put_Line("        \\O/      ");
      Put_Line("          |       ");
      Put_Line("          |      ");
      Put_Line("         /\\     ");
      Put_Line("O__/_/\\/_,\\   ");
      delay 0.2;
      Clear_Window;
      Put_Line("             ,-----------.");
      Put_Line("            ( Yeah! I win )");
      Put_Line("       \\  ,/ `-----------'");
      Put_Line("        \\O/      ");
      Put_Line("          |       ");
      Put_Line("          |      ");
      Put_Line("         /\\     ");
      Put_Line("O__/_/\\/_,\\   ");
      delay 0.2;
      Clear_Window;
   end loop;

end Kickers;

