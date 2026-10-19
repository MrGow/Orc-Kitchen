/// oPlazaExit — Step

// ====================================================
// SAFETY
// ====================================================

if (room != CentralPlaza)
{
    exit;
}

if (exit_triggered)
{
    exit;
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
// EXIT RECTANGLE
// ====================================================

var _left = x - exit_width * 0.5;
var _right = x + exit_width * 0.5;

var _top = y - exit_height * 0.5;
var _bottom = y + exit_height * 0.5;


// ====================================================
// PLAYER OVERLAP
// ====================================================

// Full player collision bounding box.
// The player must completely clear the rectangle.

var _inside =
    _player.bbox_right >= _left
    && _player.bbox_left <= _right
    && _player.bbox_bottom >= _top
    && _player.bbox_top <= _bottom;


// ====================================================
// ARM EXIT
// ====================================================

if (!exit_armed)
{
    // The player may have spawned directly
    // inside the exit rectangle.
    //
    // Wait until they walk completely away.

    if (!_inside)
    {
        exit_armed = true;

        if (global.ok_debug)
        {
            show_debug_message(
                "[PlazaExit] Armed."
            );
        }
    }

    exit;
}


// ====================================================
// CHECK EXIT OVERLAP
// ====================================================

if (!_inside)
{
    exit;
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
        "[PlazaExit] Returning to WarCampMap."
    );
}

room_goto(WarCampMap);