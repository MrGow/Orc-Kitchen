/// oPlayer — Create Event (FULL REPLACEMENT)
/// Main Orc Kitchen chef: permanent upgrades apply to base movement speed.

// ====================================================
// SPRITE
// ====================================================
sprite_index = spriteMainOrcIdle;
image_speed = 0.15;

// ====================================================
// PERMANENT CHEF UPGRADES
// ====================================================
scr_player_upgrades_init();

// Base movement remains the original 2.0.
// Apply saved/earned bonus ONCE when this room's chef is created.
// The existing Step movement and carrying penalty stay unchanged.
move_spd_base = 2.0;
move_spd = move_spd_base * (1 + global.player_upgrades.movement_speed_bonus);

carry_spd_mult = 0.88;

face_x = 0;
face_y = 1;
input_x = 0;
input_y = 0;

// ====================================================
// COLLISION / FEET PROBE
// ====================================================
feet_half_w = 9;
feet_half_h = 6;
if (!variable_global_exists("tm_solids"))
    global.tm_solids = -1;

// ====================================================
// INTERACTION
// ====================================================
interact_range = 96;
interact_key_pressed = false;
target_interact = noone;

// ====================================================
// CARRY / HELD ITEM
// ====================================================
held_kind = "";
held_sprite = -1;
held_image = 0;
held_name = "";
held_is_food = false;
held_is_dirty = false;
held_is_tool = false;
held_value = 0;
held_data = undefined;
held_draw_xoff = 0;
held_draw_yoff = -42;
held_wobble = 0;
held_wobble_amp = 0;

// ====================================================
// STATES
// ====================================================
is_carrying = false;
is_busy = false;
is_stunned = false;
drop_on_bump = true;

// ====================================================
// DEBUG / DEPTH
// ====================================================
debug_player = false;
depth = -y;
