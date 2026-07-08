/// oCustomerQueueSpot — Draw Event

if (global.debug_mode)
{
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    for (var i = 0; i < slot_count; i++)
    {
        var _sx = x + slot_xoff[i];
        var _sy = y + slot_yoff[i];

        if (queue_customer[i] != noone && instance_exists(queue_customer[i]))
        {
            draw_set_color(c_yellow);
            draw_text(_sx, _sy, "queue " + string(i + 1));
        }
        else
        {
            draw_set_color(c_lime);
            draw_text(_sx, _sy, "slot " + string(i + 1));
        }
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}