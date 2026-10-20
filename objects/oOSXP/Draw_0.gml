/// oOSXP — Draw (NEW OBJECT)

var _bob = sin(bob_clock * 0.12) * 1.5;
var _cx = round(x);
var _cy = round(y + _bob);
draw_set_alpha(0.28);
draw_set_color(c_black);
draw_ellipse(_cx - 5, round(y + 3), _cx + 5, round(y + 6), false);
draw_set_alpha(1);
draw_set_color(make_color_rgb(28, 86, 107));
draw_rectangle(_cx - 4, _cy - 4, _cx + 4, _cy + 4, false);
draw_set_color(make_color_rgb(91, 225, 249));
draw_rectangle(_cx - 3, _cy - 3, _cx + 3, _cy + 3, false);
draw_set_color(c_white);
draw_rectangle(_cx - 1, _cy - 2, _cx, _cy - 1, false);
draw_set_alpha(1);
draw_set_color(c_white);
