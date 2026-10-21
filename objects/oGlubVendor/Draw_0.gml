/// oGlubVendor — Draw
if (sprite_index != -1) draw_self();
else
{
    draw_set_color(c_black);
    draw_rectangle(x-12, y-29, x+12, y+1, false);
    draw_set_color(make_color_rgb(91, 140, 61));
    draw_rectangle(x-10, y-27, x+10, y-2, false);
    draw_set_color(make_color_rgb(225, 192, 92));
    draw_rectangle(x-9, y-20, x+9, y-17, false);
    draw_set_color(c_white);
}

if (player_near && !shop_open && !global.paused)
{
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_yellow);
    draw_text(x, y-39, "E - GLUB");
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
