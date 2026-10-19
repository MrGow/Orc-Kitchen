/// oHomeBed — Draw GUI

if (room != Home)
{
    exit;
}

if (!player_near)
{
    exit;
}

if (sleep_triggered)
{
    exit;
}

if (global.paused)
{
    exit;
}


// ====================================================
// GUI DIMENSIONS
// ====================================================

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();


// ====================================================
// PROMPT BACKGROUND
// ====================================================

var _cx = _gw * 0.5;

var _left = _cx - 116;
var _right = _cx + 116;

var _top = _gh - 57;
var _bottom = _gh - 16;

draw_set_alpha(0.90);
draw_set_color(
    make_color_rgb(29, 22, 18)
);

draw_rectangle(
    _left,
    _top,
    _right,
    _bottom,
    false
);


// ====================================================
// BORDER
// ====================================================

draw_set_alpha(1);

draw_set_color(
    make_color_rgb(155, 112, 64)
);

draw_rectangle(
    _left,
    _top,
    _right,
    _bottom,
    true
);


// ====================================================
// PROMPT TEXT
// ====================================================

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_color(c_white);

draw_text(
    _cx,
    _top + 12,
    "FILTHY BED"
);

draw_set_color(
    make_color_rgb(236, 194, 121)
);

draw_text(
    _cx,
    _top + 29,
    "Press E / Space to Sleep"
);


// ====================================================
// RESTORE DRAW STATE
// ====================================================

draw_set_color(c_white);
draw_set_alpha(1);

draw_set_halign(fa_left);
draw_set_valign(fa_top);