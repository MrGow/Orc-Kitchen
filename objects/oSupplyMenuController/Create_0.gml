/// oSupplyMenuController — Create
/// Room-local supply picker; created by a supply station.
/// NO instance needs to be placed in the Room Editor.

// The station fills these fields immediately after creation.
source_station = noone;
source_player = noone;
source_type = ""; // "meat" or "plate"
selected = 0;
items = [];

menu_age = 0;
menu_lock_frames = 9; // Don't consume the E/A press that opened this menu.
menu_anim = random(1000);

// Avoid a second supply menu.
if (instance_number(oSupplyMenuController) > 1)
{
    instance_destroy();
    exit;
}

depth = -1000;
