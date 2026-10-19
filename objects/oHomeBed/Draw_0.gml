/// oHomeBed — Draw

// ====================================================
// BED PLACEHOLDER
// ====================================================

var _left = x - bed_width * 0.5;
var _right = x + bed_width * 0.5;

var _top = y - bed_height;
var _bottom = y;


// Wooden frame.
draw_set_color(bed_frame_color);

draw_rectangle(
    _left - 3,
    _top - 3,
    _right + 3,
    _bottom + 3,
    false
);


// Blanket.
draw_set_color(bed_blanket_color);

draw_rectangle(
    _left,
    _top,
    _right,
    _bottom,
    false
);


// Pillow.
draw_set_color(bed_pillow_color);

draw_rectangle(
    _left + 5,
    _top + 4,
    _left + 17,
    _bottom - 4,
    false
);


// ====================================================
// DEBUG INTERACTION RANGE
// ====================================================

if (global.ok_debug)
{
    draw_set_alpha(0.20);
    draw_set_color(c_lime);

    draw_circle(
        x,
        y,
        interact_range,
        false
    );

    draw_set_alpha(1);
}


// ====================================================
// RESTORE DRAW STATE
// ====================================================

draw_set_color(c_white);
draw_set_alpha(1);