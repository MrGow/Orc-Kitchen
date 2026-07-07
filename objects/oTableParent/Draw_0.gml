/// oTableParent — Draw Event

draw_self();

// ----------------------------------------------------
// Draw food / dirty plates at each seat
// ----------------------------------------------------
for (var i = 0; i < seat_count; i++)
{
    var _px = round(x + plate_xoff[i]);
    var _py = round(y + plate_yoff[i]);

    if (seat_has_food[i] && seat_food_sprite[i] != -1)
    {
        draw_sprite(seat_food_sprite[i], 0, _px, _py);
    }
    else if (seat_has_dirty_plate[i])
    {
        draw_sprite(spritePlateRegular, 0, _px, _py);
    }
}

// ----------------------------------------------------
// Debug seat markers
// ----------------------------------------------------
if (global.debug_mode)
{
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    for (var j = 0; j < seat_count; j++)
    {
        var _sx = round(x + seat_xoff[j]);
        var _sy = round(y + seat_yoff[j]);

        if (seat_customer[j] != noone && instance_exists(seat_customer[j]))
        {
            draw_set_color(c_yellow);
            draw_text(_sx, _sy, "orc");
        }
        else if (seat_reserved[j])
        {
            draw_set_color(c_orange);
            draw_text(_sx, _sy, "res");
        }
        else if (seat_has_dirty_plate[j])
        {
            draw_set_color(c_red);
            draw_text(_sx, _sy, "dirty");
        }
        else
        {
            draw_set_color(c_lime);
            draw_text(_sx, _sy, "seat");
        }
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}