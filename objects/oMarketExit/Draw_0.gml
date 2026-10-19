/// oMarketExit — Draw

if (!global.ok_debug)
{
    exit;
}

var _left = x - exit_width * 0.5;
var _right = x + exit_width * 0.5;

var _top = y - exit_height * 0.5;
var _bottom = y + exit_height * 0.5;

draw_set_alpha(0.35);

if (exit_armed)
{
    draw_set_color(c_lime);
}
else
{
    draw_set_color(c_red);
}

draw_rectangle(
    _left,
    _top,
    _right,
    _bottom,
    false
);

draw_set_alpha(1);
draw_set_color(c_white);