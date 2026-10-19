/// oSleepTransition — Draw GUI
// Full-screen fading overlay and a simple animated Zzz motif.

if (transition_alpha <= 0) exit;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

// Completely black before changing rooms and throughout sleeping.
draw_set_alpha(transition_alpha);
draw_set_color(c_black);
draw_rectangle(0, 0, _gw, _gh, false);

if (transition_state == "sleep_hold")
{
    var _font = asset_get_index("PixelifyBold14");
    if (_font == -1) _font = -1;
    draw_set_font(_font);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    var _bob = round(sin(transition_frame * 0.10) * 3);
    var _cx = _gw * 0.5;
    var _cy = _gh * 0.5;

    draw_set_alpha(0.60);
    draw_set_color(c_black);
    draw_text(_cx + 2, _cy + _bob + 2, "Z z z");

    draw_set_alpha(1);
    draw_set_color(make_color_rgb(229, 212, 172));
    draw_text(_cx, _cy + _bob, "Z z z");

    draw_set_color(make_color_rgb(151, 138, 116));
    draw_text(_cx, _cy + 35, "SLEEPING...");

    draw_set_font(-1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

draw_set_alpha(1);
draw_set_color(c_white);
