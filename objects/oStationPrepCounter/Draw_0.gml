/// oStationPrepCounter — Draw Event

draw_self();

// ----------------------------------------------------
// Finished food
// ----------------------------------------------------
if (finished && finished_sprite != -1)
{
    draw_sprite(
        finished_sprite,
        0,
        round(x + finished_draw_xoff),
        round(y + finished_draw_yoff)
    );

    exit;
}

// ----------------------------------------------------
// Plate
// ----------------------------------------------------
if (has_plate && plate_sprite != -1)
{
    draw_sprite(
        plate_sprite,
        0,
        round(x + plate_draw_xoff),
        round(y + plate_draw_yoff)
    );
}

// ----------------------------------------------------
// Loose component bobbing on counter
// ----------------------------------------------------
if (has_component && component_sprite != -1)
{
    var _bob = sin(current_time * 0.006 + component_bob) * 2;

    draw_sprite(
        component_sprite,
        0,
        round(x + component_draw_xoff),
        round(y + component_draw_yoff + _bob)
    );
}