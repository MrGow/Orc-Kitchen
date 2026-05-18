/// oStationPlateHolder — Draw Event

draw_self();

// Simple debug stock display above station
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);

draw_text(x, y - sprite_height - 12, string(clean_plates) + "/" + string(max_clean_plates));

draw_set_halign(fa_left);
draw_set_valign(fa_top);