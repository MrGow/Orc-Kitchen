/// oMarketController — Step Event

var _up = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
var _down = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
var _confirm = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("E"));

if (_up) selected -= 1;
if (_down) selected += 1;

selected = clamp(selected, 0, array_length(menu_items) - 1);

if (_confirm)
{
    if (menu_items[selected] == "Back to Camp Map")
    {
        room_goto(WarCampMap);
    }
}