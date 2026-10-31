/// oMessHallExit — Step (FULL REPLACEMENT)
/// First successful departure changes CLEANUP -> EVENING.

if (exit_text_timer > 0) exit_text_timer -= 1;
if (triggered || room != MessHall || global.paused) exit;
if (instance_number(oPlayer) == 0) exit;

var _p = instance_nearest(x, y, oPlayer);
if (!instance_exists(_p)) exit;

var _inside = _p.bbox_right >= bbox_left
    && _p.bbox_left <= bbox_right
    && _p.bbox_bottom >= bbox_top
    && _p.bbox_top <= bbox_bottom;

// Spawn-inside guard: exit arms only after player leaves its bounds.
if (!exit_armed)
{
    if (!_inside)
    {
        exit_armed = true;
        if (global.ok_debug)
            show_debug_message("[MessHallExit] Armed after player left doorway.");
    }
    exit;
}

if (!_inside) exit;

if (!global.can_leave_mess_hall)
{
    if (exit_text_timer <= 0)
    {
        exit_text = "CAN'T LEAVE DURING SHIFT!";
        exit_text_timer = room_speed;
    }
    exit;
}

triggered = true;

// Leaving after cleanup starts the evening once; subsequent room visits
// never turn it back into cleanup or an active shift.
if (global.day_phase == "cleanup")
{
    global.day_phase = "evening";
    global.shift_state = "evening";
}

global.game_state = "camp_map";
global.can_leave_mess_hall = false;

if (global.ok_debug)
    show_debug_message("[MessHallExit] Leaving Mess Hall: " + global.day_phase);

room_goto(WarCampMap);
