
/// oPlayer — Create
/// Chef animations + permanent collision mask

// ====================================================
// SPRITE / ANIMATION
// ====================================================

sprite_index = spriteChefIdle;

// IMPORTANT:
// This collision mask stays the same even when
// sprite_index changes between animations.
mask_index = spriteChefCollision;

image_index = 0;
image_speed = 0;

image_xscale = 1;
image_yscale = 1;

// Animation playback speeds.
chef_run_anim_speed = 1;
chef_idle_anim_speed = 1;

// 0 = Down
// 1 = Right
// 2 = Up
// 3 = Left
chef_facing = 0;

chef_was_moving = false;


// ====================================================
// PERMANENT CHEF UPGRADES
// ====================================================

scr_player_upgrades_init();

move_spd_base = 2.0;

move_spd = move_spd_base
    * (1 + global.player_upgrades.movement_speed_bonus);

carry_spd_mult = 0.88;


// ====================================================
// FACING / INPUT
// ====================================================

face_x = 0;
face_y = 1;

input_x = 0;
input_y = 0;


// ====================================================
// COLLISION / FEET PROBE
// ====================================================

// Keep these aligned with spriteChefCollision.
feet_half_w = 9;
feet_half_h = 6;

if (!variable_global_exists("tm_solids"))
{
    global.tm_solids = -1;
}


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
