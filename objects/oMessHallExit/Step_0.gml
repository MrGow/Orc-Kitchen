/// oMessHallExit — Step Event

// ====================================================
// TEXT TIMER
// ====================================================

if (exit_text_timer > 0)
{
    exit_text_timer -= 1;
}


// ====================================================
// SAFETY
// ====================================================

if (triggered)
{
    exit;
}

if (room != MessHall)
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

var _p = instance_nearest(
    x,
    y,
    oPlayer
);

if (!instance_exists(_p))
{
    exit;
}


// ====================================================
// EXIT OVERLAP
// ====================================================

// Use collision bounding boxes.
//
// This respects the exit object's existing
// rectangle sprite/mask and room scaling.

var _inside =
    _p.bbox_right >= bbox_left
    && _p.bbox_left <= bbox_right
    && _p.bbox_bottom >= bbox_top
    && _p.bbox_top <= bbox_bottom;


// ====================================================
// ARM EXIT AFTER PLAYER LEAVES DOORWAY
// ====================================================

// The player may spawn directly inside this
// exit trigger.
//
// Do not allow it to activate until the player
// has completely moved outside its bounds.

if (!exit_armed)
{
    if (!_inside)
    {
        exit_armed = true;

        if (global.ok_debug)
        {
            show_debug_message(
                "[MessHallExit] Armed after player "
                + "left doorway."
            );
        }
    }

    exit;
}


// ====================================================
// ONLY CONTINUE WHEN PLAYER TOUCHES EXIT
// ====================================================

if (!_inside)
{
    exit;
}


// ====================================================
// BLOCK EXIT DURING ACTIVE SHIFT
// ====================================================

// global.can_leave_mess_hall remains the
// authority for whether leaving is permitted.

if (!global.can_leave_mess_hall)
{
    // Avoid resetting the message every frame.
    if (exit_text_timer <= 0)
    {
        exit_text = "CAN'T LEAVE DURING SHIFT!";
        exit_text_timer = room_speed;
    }

    exit;
}


// ====================================================
// LEAVE MESS HALL
// ====================================================

triggered = true;

global.day_phase = "camp_map";
global.game_state = "camp_map";
global.can_leave_mess_hall = false;

if (global.ok_debug)
{
    show_debug_message(
        "[MessHallExit] Auto exit to WarCampMap."
    );
}

room_goto(WarCampMap);