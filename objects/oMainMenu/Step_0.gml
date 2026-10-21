
/// oMainMenu — Step

// ====================================================
// ANIMATION
// ====================================================

menu_time += 1;


// ====================================================
// MENU NAVIGATION — oInput
// ====================================================

var move = 0;

if (global.input_up_pressed)
{
    move = -1;
}
else if (global.input_down_pressed)
{
    move = 1;
}


// ====================================================
// CHANGE SELECTION
// ====================================================

if (move != 0)
{
    repeat (menu_count)
    {
        menu_selected =
            (menu_selected + move + menu_count)
            mod menu_count;

        // Skip disabled menu options.
        if (menu_enabled[menu_selected])
        {
            break;
        }
    }
}


// ====================================================
// CONFIRM SELECTION — oInput
// ====================================================

if (
    global.input_confirm_pressed
    && menu_enabled[menu_selected]
)
{
    switch (menu_selected)
    {
        case 0:
            // NEW GAME
            room_goto(MessHall);
            break;

        case 4:
            // QUIT GAME
            game_end();
            break;
    }
}
