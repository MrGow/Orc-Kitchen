/// oStationPrepCounter — Draw Event

draw_self();

// Draw plate on counter if it has one
if (has_plate && plate_sprite != -1)
{
    draw_sprite(
        plate_sprite,
        0,
        round(x + plate_draw_xoff),
        round(y + plate_draw_yoff)
    );
}