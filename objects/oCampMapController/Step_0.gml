/// oCampMapController — Step
if (room != WarCampMap) exit;

var _up = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
var _down = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
var _confirm = keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);

if (_up) selected = max(0, selected - 1);
if (_down) selected = min(array_length(menu_items) - 1, selected + 1);

if (_confirm)
{
    switch (selected)
    {
        case 0: room_goto(Market); break;
        case 1: room_goto(CentralPlaza); break;
        case 2: room_goto(FishBattle); break;
        case 3: room_goto(Home); break;
        case 4: room_goto(MessHall); break;
    }
}
