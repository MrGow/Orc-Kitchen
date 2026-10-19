/// oPlazaExit — Draw

// ====================================================
// DEBUG ONLY
// ====================================================

if (!global.ok_debug || !debug_draw)
{
    exit;
}


// ====================================================
// RECTANGLE BOUNDS
// ====================================================

var _left = x - exit_width * 0.5;
var _right = x + exit_width * 0.5;

var _top = y - exit_height * 0.5;
var _bottom = y + exit_height * 0.5;


// ====================================================
// DRAW EXIT RECTANGLE
// ====================================================

draw_set_alpha(0.35);

if (exit_armed)
{
    draw_set_color(c_lime);
}
else
{
    draw_set_color(c_red);
}

draw_rectangle(
    _left,
    _top,
    _right,
    _bottom,
    false
);


// ====================================================
// DEBUG LABEL
// ====================================================

draw_set_alpha(1);

draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_text(
    x,
    _top - 16,
    exit_armed
        ? "PLAZA EXIT - READY"
        : "PLAZA EXIT - DISARMED"
);


// ====================================================
// RESTORE DRAW SETTINGS
// ====================================================

draw_set_alpha(1);
draw_set_color(c_white);

draw_set_halign(fa_left);
draw_set_valign(fa_top);