/// oMarketExit — Step

// ====================================================
// SAFETY
// ====================================================

if (room != Market)
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
// EXIT BOUNDS
// ====================================================

var _left = x - exit_width * 0.5;
var _right = x + exit_width * 0.5;

var _top = y - exit_height * 0.5;
var _bottom = y + exit_height * 0.5;


// ====================================================
// PLAYER OVERLAP
// ====================================================

// Use the player's collision bounding box,
// not just their origin.

var _inside =
    _player.bbox_right >= _left
    && _player.bbox_left <= _right
    && _player.bbox_bottom >= _top
    && _player.bbox_top <= _bottom;


// ====================================================
// ARM THE EXIT
// ====================================================

// If player is still touching the doorway
// after arriving, do nothing.
//
// Once player leaves completely, arm exit.

if (!exit_armed)
{
    if (!_inside)
    {
        exit_armed = true;

        if (global.ok_debug)
        {
            show_debug_message(
                "[MarketExit] Armed."
            );
        }
    }

    exit;
}


// ====================================================
// EXIT TRIGGER
// ====================================================

if (!_inside)
{
    exit;
}

exit_triggered = true;

global.game_state = "camp_map";
global.day_phase = "camp_map";
global.can_leave_mess_hall = false;

if (global.ok_debug)
{
    show_debug_message(
        "[MarketExit] Returning to camp map."
    );
}

room_goto(WarCampMap);