/// oCampMapController — Step

// ====================================================
// INPUT
// ====================================================

var _up =
    keyboard_check_pressed(vk_up)
    || keyboard_check_pressed(ord("W"));

var _down =
    keyboard_check_pressed(vk_down)
    || keyboard_check_pressed(ord("S"));

var _confirm =
    keyboard_check_pressed(vk_space)
    || keyboard_check_pressed(vk_enter)
    || keyboard_check_pressed(ord("E"));


// ====================================================
// MENU NAVIGATION
// ====================================================

if (_up)
{
    selected -= 1;
}

if (_down)
{
    selected += 1;
}

selected = clamp(
    selected,
    0,
    array_length(menu_items) - 1
);


// ====================================================
// CONFIRM LOCATION
// ====================================================

if (_confirm)
{
    var _choice = menu_items[selected];

    if (_choice == "Market")
    {
        room_goto(Market);
    }
    else if (_choice == "Central Plaza")
    {
        room_goto(CentralPlaza);
    }
    else if (_choice == "Home")
    {
        room_goto(Home);
    }
    else if (_choice == "Return to Mess Hall")
    {
        room_goto(MessHall);
    }
}