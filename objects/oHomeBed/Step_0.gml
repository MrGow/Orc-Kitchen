/// oHomeBed — Step
// Bed interaction starts the cinematic sleep transition.
// All day advancement and shift resets happen later,
// while the screen is fully black.

if (room != Home) exit;
if (sleep_triggered) exit;

player_near = false;

if (global.paused) exit;
if (variable_global_exists("sleep_transition_active"))
{
    if (global.sleep_transition_active) exit;
}

if (instance_number(oPlayer) == 0) exit;

var _player = instance_nearest(x, y, oPlayer);
if (!instance_exists(_player)) exit;

player_near = point_distance(x, y, _player.x, _player.y) <= interact_range;
if (!player_near) exit;

var _sleep_pressed = keyboard_check_pressed(ord("E"))
    || keyboard_check_pressed(vk_space);

if (!_sleep_pressed) exit;
if (!global.player_can_interact) exit;

sleep_triggered = true;

// Prevent input and shift processing immediately.
global.sleep_transition_active = true;
global.player_can_move = false;
global.player_can_interact = false;

// Only the transition controller advances the day.
instance_create_depth(0, 0, -1000000, oSleepTransition);

if (global.ok_debug)
    show_debug_message("[HomeBed] Sleeping transition started.");
