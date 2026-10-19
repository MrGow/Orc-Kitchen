/// oSocialCinematic — Create

// ====================================================
// CINEMATIC LETTERBOX SETTINGS
// ====================================================

// Bar height in GUI pixels, calibrated for 640x360.
bar_target_height = 30;

// Time to animate from hidden to fully visible.
bar_animation_duration = 0.30;

// Current progress: 0 = hidden, 1 = visible.
bar_progress = 0;

// Target progress.
bar_target = 0;


// ====================================================
// SHARED DISPLAY VALUES
// ====================================================

// The social dialogue uses these values to keep
// text out of the cinematic bars.

global.social_cine_bar_height = 0;
global.social_cine_active = false;


// ====================================================
// PRESENTATION
// ====================================================

visible = true;

// Draw GUI uses the object's depth for ordering.
// The dialogue stays inside the unobstructed region.
depth = -9000;