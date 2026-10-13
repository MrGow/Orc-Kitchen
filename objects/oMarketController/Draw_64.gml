/// oMarketController — Draw GUI Event

var _gw = display_get_gui_width();

draw_set_halign(fa_center);
draw_set_valign(fa_top);

draw_set_color(c_yellow);
draw_text(_gw * 0.5, 48, "MARKET");

draw_set_color(c_white);
draw_text(_gw * 0.5, 80, "Placeholder shop");

for (var i = 0; i < array_length(menu_items); i++)
{
    var _txt = menu_items[i];

    if (i == selected)
    {
        draw_set_color(c_lime);
        _txt = "> " + _txt + " <";
    }
    else
    {
        draw_set_color(c_white);
    }

    draw_text(_gw * 0.5, 140 + i * 32, _txt);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);