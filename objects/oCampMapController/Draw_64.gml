/// oCampMapController — Draw GUI
if (room != WarCampMap) exit;
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _font = asset_get_index("PixelifyRegular12");
var _title = asset_get_index("PixelifyBold14");
if (_title == -1) _title = _font;

draw_set_alpha(1);
draw_set_color(make_color_rgb(27, 24, 20));
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_font(_title);
draw_set_color(make_color_rgb(233, 196, 113));
draw_text(_gw * 0.5, 44, "WAR CAMP");

draw_set_font(_font);
var _spacing = 34;
var _y0 = 101;
for (var _i = 0; _i < array_length(menu_items); _i++)
{
    var _yy = _y0 + _i * _spacing;
    if (_i == selected)
    {
        draw_set_color(make_color_rgb(81, 58, 36));
        draw_rectangle(_gw * 0.5 - 127, _yy - 5, _gw * 0.5 + 127, _yy + 23, false);
    }
    draw_set_color(_i == selected ? c_yellow : make_color_rgb(225, 207, 172));
    draw_text(_gw * 0.5, _yy, (_i == selected ? "> " : "") + menu_items[_i] + (_i == selected ? " <" : ""));
}
draw_set_color(make_color_rgb(177, 167, 144));
draw_text(_gw * 0.5, _gh - 35, "W / S: CHOOSE     E / ENTER: TRAVEL");
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
