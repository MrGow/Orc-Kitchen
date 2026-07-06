/// oGame — Draw GUI
// Temporary debug/status HUD.
// Later we can replace this with proper Orc Kitchen UI.

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

if (_gw <= 0) _gw = global.GUI_W;
if (_gh <= 0) _gh = global.GUI_H;

// ----------------------------------------------------
// Pause overlay
// ----------------------------------------------------
if (global.paused)
{
    draw_set_alpha(0.55);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(_gw * 0.5, _gh * 0.5, "PAUSED");

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    exit;
}

