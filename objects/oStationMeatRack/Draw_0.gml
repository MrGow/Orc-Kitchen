/// oStationMeatRack — Draw
// Stock display during development.
draw_self();
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(Silkscreen10);
draw_set_color(c_white);
draw_text(x, y - sprite_height - 12,
    "RAT " + string(stock_rat) + " / BAT " + string(stock_bat));
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
draw_set_color(c_white);
