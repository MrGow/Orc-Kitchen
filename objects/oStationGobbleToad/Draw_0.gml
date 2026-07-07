/// oStationGobbleToad — Draw Event

draw_self();

// ----------------------------------------------------
// Floating feedback text
// ----------------------------------------------------
if (gobble_text_timer > 0)
{
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    if (gobble_text == "CHOMP!")
    {
        draw_set_color(c_lime);
    }
    else
    {
        draw_set_color(c_red);
    }

    var _bob = sin(current_time * 0.012) * 2;

    draw_text(
        x,
        y - sprite_height - 18 + _bob,
        gobble_text
    );

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}