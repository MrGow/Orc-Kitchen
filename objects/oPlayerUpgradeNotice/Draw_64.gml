/// oPlayerUpgradeNotice — Draw GUI

if (room != Home || !notice_active) exit;
if (is_undefined(notice_data)) exit;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _w = min(400, _gw - 24);
var _h = 112;
var _x = round((_gw - _w) * 0.5);
var _y = round((_gh - _h) * 0.5);

var _alpha = 1;
if (notice_timer < notice_fade_frames)
    _alpha = clamp(notice_timer / notice_fade_frames, 0, 1);

var _font_title = asset_get_index("PixelifyBold14");
var _font_body = asset_get_index("PixelifyRegular12");

draw_set_alpha(0.55 * _alpha);
draw_set_color(c_black);
draw_rectangle(_x + 4, _y + 5, _x + _w + 4, _y + _h + 5, false);

draw_set_alpha(0.96 * _alpha);
draw_set_color(make_color_rgb(33, 26, 20));
draw_rectangle(_x, _y, _x + _w, _y + _h, false);

draw_set_alpha(_alpha);
draw_set_color(make_color_rgb(182, 142, 74));
draw_rectangle(_x, _y, _x + _w, _y + _h, true);

draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_font(_font_title);
draw_set_color(make_color_rgb(246, 204, 121));
draw_text(_gw * 0.5, _y + 10, notice_data.title);

draw_set_font(_font_body);
draw_set_color(make_color_rgb(242, 228, 204));
draw_text(_gw * 0.5, _y + 37, notice_data.message);

draw_set_color(make_color_rgb(155, 218, 138));
draw_text(_gw * 0.5, _y + 60, notice_data.reward);

draw_set_color(make_color_rgb(193, 171, 136));
draw_text(_gw * 0.5, _y + 84, notice_data.total);

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
