/// oSolidBlock — Draw Event

if (global.debug_mode && show_debug_collision)
{
    draw_set_alpha(0.25);
    draw_set_color(c_red);
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
}