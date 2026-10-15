/// oMainMenu — Create

// ====================================================
// MENU OPTIONS
// ====================================================

menu_items =
[
    "NEW GAME",
    "CONTINUE",
    "LOAD GAME",
    "SETTINGS",
    "QUIT GAME"
];

menu_count = array_length(menu_items);

menu_selected = 0;


// ====================================================
// ENABLED OPTIONS
// ====================================================

// Continue, Load Game and Settings are placeholders.
menu_enabled =
[
    true,
    false,
    false,
    false,
    true
];


// ====================================================
// FONTS
// ====================================================

font_title = MedievalSharpRegular32;
font_menu  = MedievalSharpRegular20;
font_small = PixelifyRegular12;


// ====================================================
// COLOURS
// ====================================================

col_background = make_color_rgb(24, 20, 25);
col_title      = make_color_rgb(235, 198, 135);
col_normal     = make_color_rgb(210, 195, 170);
col_selected   = make_color_rgb(255, 220, 125);
col_disabled   = make_color_rgb(105, 96, 93);


// ====================================================
// LAYOUT
// ====================================================

title_y = 65;

menu_start_y = 155;
menu_spacing = 34;


// ====================================================
// ANIMATION
// ====================================================

menu_time = 0;