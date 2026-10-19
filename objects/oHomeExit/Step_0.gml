/// oHomeExit — Step

// ====================================================
// SAFETY
// ====================================================

if (room != Home)
{
    exit;
}

if (exit_triggered)
{
    exit;
}

if (message_timer > 0)
{
    message_timer -= 1;
}

if (global.paused)
{
    exit;
}


// ====================================================
// FIND PLAYER
// ====================================================

if (instance_number(oPlayer) == 0)
{
    exit;
}

var _player = instance_nearest(
    x,
    y,
    oPlayer
);

if (!instance_exists(_player))
{
    exit;
}


// ====================================================
// EXIT BOUNDS
// ====================================================

var _left = x - exit_width * 0.5;
var _right = x + exit_width * 0.5;

var _top = y - exit_height * 0.5;
var _bottom = y + exit_height * 0.5;


// ====================================================
// PLAYER OVERLAP
// ====================================================

var _inside =
    _player.bbox_right >= _left
    && _player.bbox_left <= _right
    && _player.bbox_bottom >= _top
    && _player.bbox_top <= _bottom;


// ====================================================
// ARM EXIT AFTER LEAVING DOORWAY
// ====================================================

if (!exit_armed)
{
    if (!_inside)
    {
        exit_armed = true;

        if (global.ok_debug)
        {
            show_debug_message(
                "[HomeExit] Armed."
            );
        }
    }

    exit;
}


// ====================================================
// CHECK IF PLAYER ENTERED EXIT
// ====================================================

if (!_inside)
{
    exit;
}


// ====================================================
// EVENING RESTRICTION
// ====================================================

if (variable_global_exists("evening_activity_used"))
{
    if (global.evening_activity_used)
    {
        if (message_timer <= 0)
        {
            message_timer = message_duration;
        }

        exit;
    }
}


// ====================================================
// RETURN TO CAMP MAP
// ====================================================

exit_triggered = true;

global.game_state = "camp_map";
global.day_phase = "camp_map";
global.can_leave_mess_hall = false;

if (global.ok_debug)
{
    show_debug_message(
        "[HomeExit] Returning to camp map."
    );
}

room_goto(WarCampMap);