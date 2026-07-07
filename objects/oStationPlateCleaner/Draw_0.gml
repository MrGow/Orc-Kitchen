/// oStationPlateCleaner — Draw Event

draw_self();

// ----------------------------------------------------
// Washing progress bar
// ----------------------------------------------------
if (washing)
{
    var _bar_w = 72;
    var _bar_h = 6;
    var _xx = x - _bar_w * 0.5;
    var _yy = y - sprite_height - 14;

    var _p = wash_progress / wash_time;

    draw_set_color(c_black);
    draw_rectangle(_xx, _yy, _xx + _bar_w, _yy + _bar_h, false);

    draw_set_color(c_lime);
    draw_rectangle(_xx, _yy, _xx + _bar_w * _p, _yy + _bar_h, false);
}

// ----------------------------------------------------
// Show clean plate ready
// ----------------------------------------------------
if (clean_ready > 0)
{
    draw_sprite(
        spritePlateRegular,
        0,
        round(x + plate_draw_xoff),
        round(y + plate_draw_yoff)
    );
}

// ----------------------------------------------------
// Debug queue text
// ----------------------------------------------------
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_color(c_white);
draw_text(
    x,
    y - sprite_height - 28,
    "Dirty: " + string(dirty_queue) + "  Clean: " + string(clean_ready)
);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);