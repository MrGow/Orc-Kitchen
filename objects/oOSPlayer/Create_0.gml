/// oOSPlayer — Create (FULL REPLACEMENT)

// Movement and facing
move_speed = 2.5;
move_x = 0;
move_y = 0;
facing = 1;
edge_margin = 12;
walk_animation_speed = 0.14;
image_speed = 0;
image_index = 0;
image_xscale = 1;
image_yscale = 1;

// Health, i-frames, impact feedback
max_hp = 100;
hp = max_hp;
previous_hp = hp;
invulnerability_timer = 0;
iframe_blink_interval = 4;
hit_flash_timer = 0;
hit_flash_duration = 9;
hit_shake_duration = max(1, round(room_speed * 0.18));
hit_shake_timer = 0;
hit_shake_strength = 3;

// Experience and level progression (session-only for now)
level = 1;
xp = 0;
xp_next = 5;
xp_pickup_radius = 16;

// Automatic wide axe swipe
axe_damage = 2;
axe_range = 69;
axe_arc = 150; // degrees
axe_cooldown = max(1, round(room_speed * 0.85));
axe_cooldown_timer = round(room_speed * 0.35);
axe_active_duration = 12;
axe_active_timer = 0;
axe_angle = 0;
axe_swing_id = 0;

// Optional second weapon: orbiting cleavers (unlocked by upgrade)
cleaver_count = 0;
cleaver_damage = 1;
cleaver_orbit_radius = 46;
cleaver_hit_radius = 12;
cleaver_rotation = 0;
cleaver_rotation_speed = 3.7;

// Render order
depth = -1000;
