/// oMessHallExit — Step Event

if (exit_text_timer > 0)
{
    exit_text_timer -= 1;
}

// Already triggered room transition.
if (triggered)
{
    exit;
}

// Only works in the mess hall.
if (room != MessHall)
{
    exit;
}

// Find player.
var _p = noone;

if (object_exists(oPlayer))
{
    _p = instance_nearest(x, y, oPlayer);
}

if (_p == noone || !instance_exists(_p))
{
    exit;
}

// Check overlap between player and this exit rectangle.
if (place_meeting(x, y, oPlayer))
{
    // ------------------------------------------------
    // Block exit during active cooking phases
    // ------------------------------------------------
    if (!global.can_leave_mess_hall)
    {
        exit_text = "CAN'T LEAVE DURING SHIFT!";
        exit_text_timer = room_speed;

        exit;
    }

    // ------------------------------------------------
    // Allowed to leave
    // ------------------------------------------------
    triggered = true;

    global.day_phase = "camp_map";
    global.game_state = "camp_map";
    global.can_leave_mess_hall = false;

    show_debug_message("[MessHallExit] Auto exit to WarCampMap.");

    room_goto(WarCampMap);
}