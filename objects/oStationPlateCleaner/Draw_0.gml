/// oStationPlateCleaner — Draw Event

draw_self();

// Show washing progress
if (washing)
{
    var _bar_w = 64;
    var _bar_h = 6;
    var _xx = x - _bar_w * 0.5;
    var _yy = y - sprite_height - 12;

    var _p = wash_progress / wash_time;

    draw_set_color(c_black);
    draw_rectangle(_xx, _yy, _xx + _bar_w, _yy + _bar_h, false);

    draw_set_color(c_lime);
    draw_rectangle(_xx, _yy, _xx + _bar_w * _p, _yy + _bar_h, false);
}

// Show clean plate ready
if (clean_plate_ready)
{
    draw_sprite(
        spritePlateRegular,
        0,
        round(x + plate_draw_xoff),
        round(y + plate_draw_yoff)
    );
}