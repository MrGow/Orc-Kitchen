/// oOSArcadeCabinet — Step

// ====================================================
// ROOM SAFETY
// ====================================================

if (room != Home)
{
    exit;
}


// ====================================================
// PURCHASE STATUS
// ====================================================

// Check every frame so a purchase can become
// visible without needing to recreate the object.

visible = global.arcade_owned;

player_near = false;


// ====================================================
// TEMPORARY DEBUG PURCHASE
// ====================================================

// F8 grants the cabinet for testing.
// Only when Orc Kitchen debug mode is enabled.

if (variable_global_exists("ok_debug"))
{
    if (global.ok_debug)
    {
        if (keyboard_check_pressed(vk_f8))
        {
            global.arcade_owned = true;
            visible = true;

            show_debug_message(
                "[Orc Survivors] Cabinet unlocked."
            );
        }
    }
}


// ====================================================
// HIDDEN UNTIL PURCHASED
// ====================================================

if (!global.arcade_owned)
{
    exit;
}


// ====================================================
// GLOBAL STATE SAFETY
// ====================================================

if (global.paused)
{
    exit;
}

if (!global.player_can_interact)
{
    exit;
}

if (variable_global_exists("sleep_transition_active"))
{
    if (global.sleep_transition_active)
    {
        exit;
    }
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
// PLAYER DISTANCE
// ====================================================

var _distance = point_distance(
    x,
    y,
    _player.x,
    _player.y
);

player_near = (_distance <= interact_range);

if (!player_near)
{
    exit;
}


// ====================================================
// INPUT
// ====================================================

var _pressed =
    keyboard_check_pressed(ord("E"))
    || keyboard_check_pressed(vk_space);

if (!_pressed)
{
    exit;
}


// ====================================================
// EVENING ACTIVITY CHECK
// ====================================================

if (!variable_global_exists("evening_activity_used"))
{
    global.evening_activity_used = false;
}

if (global.evening_activity_used)
{
    // Cabinet remains interactable on future days.
    // For now we simply refuse to enter again.
    show_debug_message(
        "[Orc Survivors] Evening already used."
    );

    exit;
}


// ====================================================
// BEGIN ARCADE SESSION
// ====================================================

// Spend this evening on the arcade.
global.evening_activity_used = true;

// Close any kitchen UI.
global.recipe_menu_open = false;
global.paused = false;

// Lock interactions until the new room loads.
global.player_can_move = false;
global.player_can_interact = false;

show_debug_message(
    "[Orc Survivors] Entering arcade. Wave "
    + string(global.os_wave)
);


// ====================================================
// ENTER MINIGAME
// ====================================================

room_goto(OrcSurvivorsRoom);