/// oMainMenu — Draw GUI

var gw = display_get_gui_width();
var gh = display_get_gui_height();

var cx = gw * 0.5;
var scale = gh / 360;


// ====================================================
// BACKGROUND
// ====================================================

draw_set_alpha(1);
draw_set_color(col_background);

draw_rectangle(0, 0, gw, gh, false);


// ====================================================
// BACKGROUND GRADIENT
// ====================================================

draw_rectangle_color(
    0, 0, gw, gh,
    make_color_rgb(45, 34, 35),
    make_color_rgb(45, 34, 35),
    col_background,
    col_background,
    false
);


// ====================================================
// TITLE
// ====================================================

draw_set_font(font_title);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_color(col_title);

draw_text(
    cx,
    title_y * scale,
    "ORC KITCHEN"
);


// ====================================================
// TITLE UNDERLINE
// ====================================================

var line_y = 96 * scale;

draw_set_color(make_color_rgb(135, 91, 59));

draw_line_width(
    cx - 115 * scale,
    line_y,
    cx + 115 * scale,
    line_y,
    2
);


// ====================================================
// MENU OPTIONS
// ====================================================

draw_set_font(font_menu);

for (var i = 0; i < menu_count; i++)
{
    var yy =
        (menu_start_y + i * menu_spacing) * scale;

    var txt = menu_items[i];

    if (!menu_enabled[i])
    {
        draw_set_color(col_disabled);
    }
    else if (i == menu_selected)
    {
        draw_set_color(col_selected);
    }
    else
    {
        draw_set_color(col_normal);
    }

    draw_text(cx, yy, txt);

    // Selection indicators.
    if (i == menu_selected && menu_enabled[i])
    {
        var half_w = string_width(txt) * 0.5;

        var marker_offset = 18 * scale;

        draw_text(
            cx - half_w - marker_offset,
            yy,
            ">"
        );

        draw_text(
            cx + half_w + marker_offset,
            yy,
            "<"
        );
    }
}


// ====================================================
// FOOTER
// ====================================================

draw_set_font(font_small);

draw_set_color(make_color_rgb(125, 112, 102));

draw_text(
    cx,
    gh - 18 * scale,
    "A FINE DINING DISASTER"
);


// ====================================================
// RESET DRAW STATE
// ====================================================

draw_set_color(c_white);
draw_set_alpha(1);

draw_set_halign(fa_left);
draw_set_valign(fa_top);