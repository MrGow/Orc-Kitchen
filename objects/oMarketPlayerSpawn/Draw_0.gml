/// oMarketPlayerSpawn — Draw Event
// Marker is invisible outside debug mode.
if (global.ok_debug)
{
    draw_set_color(c_aqua);
    draw_set_alpha(0.45);
    draw_circle(x, y, 12, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
}
