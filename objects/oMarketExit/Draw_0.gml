/// oMarketExit — Draw Event
// Debug-only rectangle; do NOT draw_self() in production.
if (global.ok_debug && debug_draw)
{
    draw_set_alpha(0.25);
    draw_set_color(c_aqua);
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text((bbox_left + bbox_right) * 0.5, bbox_top - 20, "TO WAR CAMP");
    draw_set_halign(fa_left);
}
