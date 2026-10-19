/// oHomeBed — Create

// ====================================================
// INTERACTION
// ====================================================

// Distance from bed origin required to sleep.
interact_range = 48;

// Player proximity.
player_near = false;

// Prevent repeated room-transition requests.
sleep_triggered = false;


// ====================================================
// PLACEHOLDER BED
// ====================================================

bed_width = 52;
bed_height = 30;

// Placeholder rectangle colours.
bed_frame_color = make_color_rgb(75, 43, 24);
bed_blanket_color = make_color_rgb(120, 46, 36);
bed_pillow_color = make_color_rgb(179, 165, 131);


// ====================================================
// VISUALS
// ====================================================

// Room/world-space depth.
depth = -y;