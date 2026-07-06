/// oStationGrill — Draw Event

draw_self();

// Draw food on grill
if (has_food && food_sprite != -1)
{
    draw_sprite(
        food_sprite,
        0,
        round(x + food_draw_xoff),
        round(y + food_draw_yoff)
    );
}

// Progress bar
if (has_food)
{
    var _bar_w = 72;
    var _bar_h = 6;
    var _xx = x - _bar_w * 0.5;
    var _yy = y - sprite_height - 12;

    var _p = clamp(cook_timer / cook_time_burnt, 0, 1);

    draw_set_color(c_black);
    draw_rectangle(_xx, _yy, _xx + _bar_w, _yy + _bar_h, false);

    if (cook_state == "raw") draw_set_color(c_yellow);
    else if (cook_state == "cooked") draw_set_color(c_lime);
    else if (cook_state == "burnt") draw_set_color(c_red);

    draw_rectangle(_xx, _yy, _xx + _bar_w * _p, _yy + _bar_h, false);
}