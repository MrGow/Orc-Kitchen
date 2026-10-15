/// oMainMenu — Step

// ====================================================
// ANIMATION
// ====================================================

menu_time += 1;


// ====================================================
// KEYBOARD NAVIGATION
// ====================================================

var move = 0;

if (keyboard_check_pressed(vk_up))
{
    move = -1;
}

if (keyboard_check_pressed(vk_down))
{
    move = 1;
}

if (move != 0)
{
    repeat (menu_count)
    {
        menu_selected =
            (menu_selected + move + menu_count)
            mod menu_count;

        if (menu_enabled[menu_selected])
        {
            break;
        }
    }
}


// ====================================================
// MOUSE NAVIGATION
// ====================================================

var gw = display_get_gui_width();
var gh = display_get_gui_height();

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

var menu_scale = gh / 360;

var menu_y = menu_start_y * menu_scale;
var spacing = menu_spacing * menu_scale;

draw_set_font(font_menu);

for (var i = 0; i < menu_count; i++)
{
    var yy = menu_y + i * spacing;

    var half_w =
        string_width(menu_items[i]) * 0.5 + 15;

    var half_h =
        string_height(menu_items[i]) * 0.5 + 7;

    if (
        mx >= gw * 0.5 - half_w
        && mx <= gw * 0.5 + half_w
        && my >= yy - half_h
        && my <= yy + half_h
    )
    {
        if (menu_enabled[i])
        {
            menu_selected = i;
        }
    }
}


// ====================================================
// CONFIRM SELECTION
// ====================================================

var confirm = keyboard_check_pressed(vk_enter)
    || keyboard_check_pressed(vk_space);

if (mouse_check_button_pressed(mb_left))
{
    var yy = menu_y + menu_selected * spacing;

    var half_w =
        string_width(menu_items[menu_selected]) * 0.5 + 15;

    var half_h =
        string_height(menu_items[menu_selected]) * 0.5 + 7;

    if (
        mx >= gw * 0.5 - half_w
        && mx <= gw * 0.5 + half_w
        && my >= yy - half_h
        && my <= yy + half_h
    )
    {
        confirm = true;
    }
}

if (confirm && menu_enabled[menu_selected])
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