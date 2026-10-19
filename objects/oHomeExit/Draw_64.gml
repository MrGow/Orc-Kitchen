/// oHomeExit — Draw GUI

if (room != Home)
{
    exit;
}

if (message_timer <= 0)
{
    exit;
}


// ====================================================
// MESSAGE
// ====================================================

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

var _cx = _gw * 0.5;
var _cy = _gh - 40;


// Background.
draw_set_alpha(0.88);
draw_set_color(c_black);

draw_rectangle(
    _cx - 125,
    _cy - 16,
    _cx + 125,
    _cy + 16,
    false
);


// Text.
draw_set_alpha(1);
draw_set_color(c_white);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_text(
    _cx,
    _cy,
    "It's way too late to go out!"
);


// Restore.
draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_set_color(c_white);
draw_set_alpha(1);