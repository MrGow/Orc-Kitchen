/// oSocialCinematic — Draw GUI

if (bar_progress <= 0)
{
    exit;
}


// ====================================================
// GUI DIMENSIONS
// ====================================================

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();


// ====================================================
// SCALED BAR HEIGHT
// ====================================================

var _bar_h =
    round(bar_target_height * bar_progress);

_bar_h = clamp(
    _bar_h,
    0,
    floor(_gh * 0.25)
);


// ====================================================
// DRAW BLACK LETTERBOX BARS
// ====================================================

draw_set_alpha(1);
draw_set_color(c_black);

// Top bar.
draw_rectangle(
    0,
    0,
    _gw,
    _bar_h,
    false
);

// Bottom bar.
draw_rectangle(
    0,
    _gh - _bar_h,
    _gw,
    _gh,
    false
);


// ====================================================
// RESTORE DRAW STATE
// ====================================================

draw_set_color(c_white);
draw_set_alpha(1);