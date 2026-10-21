/// oOSArcadeCabinet — Step (FULL REPLACEMENT)
// Opens the title for free; the evening is spent only on SPACE to PLAY.

if (room != Home) exit;

// Existing ownership is preserved by the Create event.
if (!variable_global_exists("arcade_owned")) global.arcade_owned = false;
visible = global.arcade_owned;
player_near = false;

// Temporary F8 unlock from the original prototype.
if (variable_global_exists("ok_debug"))
{
    if (global.ok_debug && keyboard_check_pressed(vk_f8))
    {
        global.arcade_owned = true;
        visible = true;
        show_debug_message("[Orc Survivors] Cabinet unlocked.");
    }
}

if (!global.arcade_owned) exit;
if (global.paused || !global.player_can_interact) exit;
if (variable_global_exists("sleep_transition_active"))
{
    if (global.sleep_transition_active) exit;
}
if (!instance_exists(oPlayer)) exit;

var _player = instance_nearest(x, y, oPlayer);
if (!instance_exists(_player)) exit;

player_near = point_distance(x, y, _player.x, _player.y) <= interact_range;
if (!player_near) exit;

var _pressed = keyboard_check_pressed(ord("E"))
    || keyboard_check_pressed(vk_space);
if (gamepad_is_connected(0))
{
    if (gamepad_button_check_pressed(0, gp_face1)) _pressed = true;
}
if (!_pressed) exit;

if (!variable_global_exists("evening_activity_used"))
    global.evening_activity_used = false;

if (global.evening_activity_used)
{
    show_debug_message("[Orc Survivors] Evening already used.");
    exit;
}

// This is a FREE title preview. The controller commits the evening on Start.
global.recipe_menu_open = false;
global.paused = false;
global.player_can_move = false;
global.player_can_interact = false;
room_goto(OrcSurvivorsRoom);
