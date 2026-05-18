/// oPlayer — Create Event
// Basic top-down player controller for Orc Kitchen
// Temp sprite: spriteMainOrcIdle

// ----------------------------------------------------
// Sprite setup
// ----------------------------------------------------
sprite_index = spriteMainOrcIdle;
image_speed  = 0.15;

// ----------------------------------------------------
// Movement
// ----------------------------------------------------
move_spd = 2.0;

// Slight speed penalty while carrying something.
// Keep this mild early on.
carry_spd_mult = 0.88;

// Last facing direction.
// Used later for interact direction / animation.
face_x = 0;
face_y = 1;

// Current movement input
input_x = 0;
input_y = 0;

// ----------------------------------------------------
// Collision / feet probe
// ----------------------------------------------------
// Top-down collision uses a small "feet box" rather than the full sprite.
// This avoids the head/arms catching on walls.
feet_half_w = 9;
feet_half_h = 6;

// Optional tilemap support.
// If oGame later sets global.tm_solids, this player will use it.
// If not set, player moves freely.
if (!variable_global_exists("tm_solids"))
{
    global.tm_solids = -1;
}

// ----------------------------------------------------
// Interaction
// ----------------------------------------------------
interact_range = 56;
interact_key_pressed = false;

// The nearest thing we could interact with.
target_interact = noone;

// ----------------------------------------------------
// Carry / held item system
// ----------------------------------------------------
// Universal carry idea:
// Player uses one carry pose later, and the carried item sprite draws above his head.
held_kind        = ""; // "", "plate_clean", "plate_dirty", later "food", "tool", etc.
held_sprite      = -1;
held_image       = 0;
held_name        = "";
held_is_food     = false;
held_is_dirty    = false;
held_is_tool     = false;
held_value       = 0;
held_data        = undefined;

// Draw offset for item above head.
// Adjust after seeing your sprite.
held_draw_xoff   = 0;
held_draw_yoff   = -42;

// Optional wobble for big plates later
held_wobble      = 0;
held_wobble_amp  = 0;

// ----------------------------------------------------
// State flags
// ----------------------------------------------------
is_carrying = false;
is_busy     = false;
is_stunned  = false;

// For boss day / collision hazards later
drop_on_bump = true;

// ----------------------------------------------------
// Debug
// ----------------------------------------------------
debug_player = false;

// Depth sorting
depth = -y;