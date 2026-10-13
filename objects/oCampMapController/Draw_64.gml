/// oCampMapController — Draw GUI Event

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

draw_set_color(c_black);
draw_rectangle(0, 0, _gw, _gh, false);

draw_set_halign(fa_center);
draw_set_valign(fa_top);

draw_set_color(c_yellow);
draw_text(_gw * 0.5, 48, "WAR CAMP MAP");

draw_set_color(c_white);
draw_text(_gw * 0.5, 80, "Choose where to go");

var _start_y = 140;
var _gap = 32;

for (var i = 0; i < array_length(menu_items); i++)
{
    if (i == selected)
    {
        draw_set_color(c_lime);
        draw_text(_gw * 0.5, _start_y + i * _gap, "> " + menu_items[i] + " <");
    }
    else
    {
        draw_set_color(c_white);
        draw_text(_gw * 0.5, _start_y + i * _gap, menu_items[i]);
    }
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);