/// oMainMenu — Draw GUI
/// Original fonts retained; subtle dark outlining for clarity.

var gw = display_get_gui_width();
var gh = display_get_gui_height();
var cx = gw * 0.5;
var scale = gh / 360;

// One-pixel dark outline without changing the chosen font.
var _menu_text = function(_x, _y, _str, _col, _outline)
{
    if (_outline)
    {
        draw_set_color(make_color_rgb(24, 14, 15));
        draw_text(_x - 1, _y, _str);
        draw_text(_x + 1, _y, _str);
        draw_text(_x, _y - 1, _str);
        draw_text(_x, _y + 1, _str);
    }
    draw_set_color(_col);
    draw_text(_x, _y, _str);
};

// BACKGROUND
draw_set_alpha(1);
draw_set_color(col_background);
draw_rectangle(0, 0, gw, gh, false);

// BACKGROUND GRADIENT
draw_rectangle_color(
    0, 0, gw, gh,
    make_color_rgb(45, 34, 35),
    make_color_rgb(45, 34, 35),
    col_background, col_background, false);

// TITLE — original font
draw_set_font(font_title);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
_menu_text(cx, title_y * scale, "ORC KITCHEN", col_title, true);

// TITLE UNDERLINE
var line_y = 96 * scale;
draw_set_color(make_color_rgb(157, 109, 69));
draw_line_width(cx - 115 * scale, line_y,
    cx + 115 * scale, line_y, 2);

// MENU OPTIONS — original font
draw_set_font(font_menu);
for (var i = 0; i < menu_count; i++)
{
    var yy = (menu_start_y + i * menu_spacing) * scale;
    var txt = menu_items[i];

    var _col = col_normal;
    if (!menu_enabled[i]) _col = col_disabled;
    else if (i == menu_selected) _col = col_selected;

    _menu_text(cx, yy, txt, _col,
        (i == menu_selected && menu_enabled[i]));

    if (i == menu_selected && menu_enabled[i])
    {
        var half_w = string_width(txt) * 0.5;
        var marker_offset = 18 * scale;
        _menu_text(cx - half_w - marker_offset, yy, ">", _col, true);
        _menu_text(cx + half_w + marker_offset, yy, "<", _col, true);
    }
}

// FOOTER — original font, slightly warmer and lighter colour.
draw_set_font(font_small);
_menu_text(cx, gh - 18 * scale,
    "A FINE DINING DISASTER",
    make_color_rgb(166, 147, 127), false);

// RESET DRAW STATE
draw_set_font(-1);
draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
