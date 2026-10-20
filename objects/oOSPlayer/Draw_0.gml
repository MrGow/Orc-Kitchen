/// oOSPlayer — Draw (FULL REPLACEMENT)

var _xx = round(x);
var _yy = round(y);
var _alpha = 1;
var _tint = c_white;

if (invulnerability_timer > 0)
{
    if ((floor(invulnerability_timer / max(1, iframe_blink_interval)) mod 2) == 0)
        _alpha = 0.4;
}
if (hit_flash_timer > 0)
{
    _tint = make_color_rgb(255, 155, 155);
    _alpha = 1;
}

if (sprite_index != -1)
{
    draw_sprite_ext(sprite_index, floor(image_index), _xx, _yy, facing, 1, 0, _tint, _alpha);
}
else
{
    // Simple Orc placeholder, preserving hit feedback.
    draw_set_alpha(0.3);
    draw_set_color(c_black);
    draw_ellipse(_xx - 9, _yy + 7, _xx + 9, _yy + 12, false);
    draw_set_alpha(_alpha);
    draw_set_color(hit_flash_timer > 0 ? make_color_rgb(255, 155, 155) : make_color_rgb(65, 116, 48));
    draw_rectangle(_xx - 8, _yy - 7, _xx + 8, _yy + 9, false);
    draw_set_color(hit_flash_timer > 0 ? make_color_rgb(255, 210, 210) : make_color_rgb(104, 163, 69));
    draw_rectangle(_xx - 7, _yy - 14, _xx + 7, _yy - 4, false);
    draw_set_color(c_white);
    draw_rectangle(_xx + facing * 2 - 2, _yy - 11, _xx + facing * 2, _yy - 9, false);
}

// Big luminous arc, active for a short fraction of a second.
// GameMaker angles increase counterclockwise; build the arc from line segments.
if (axe_active_timer > 0)
{
    var _fraction = axe_active_timer / max(1, axe_active_duration);
    var _radius = axe_range;
    var _start = axe_angle - axe_arc * 0.5;
    var _segments = 20;
    var _last_x = x + lengthdir_x(_radius, _start);
    var _last_y = y + lengthdir_y(_radius, _start);

    draw_set_alpha(min(1, _fraction * 1.5));
    for (var _j = 1; _j <= _segments; _j++)
    {
        var _angle = _start + axe_arc * _j / _segments;
        var _next_x = x + lengthdir_x(_radius, _angle);
        var _next_y = y + lengthdir_y(_radius, _angle);
        draw_set_color(make_color_rgb(255, 180, 81));
        draw_line_width(_last_x, _last_y, _next_x, _next_y, 9);
        draw_set_color(make_color_rgb(255, 243, 194));
        draw_line_width(_last_x, _last_y, _next_x, _next_y, 3);
        _last_x = _next_x;
        _last_y = _next_y;
    }
}

// New weapon visual: orbiting steel cleavers.
if (cleaver_count > 0)
{
    draw_set_alpha(1);
    for (var _k = 0; _k < cleaver_count; _k++)
    {
        var _a = cleaver_rotation + _k * 360 / cleaver_count;
        var _cx = round(x + lengthdir_x(cleaver_orbit_radius, _a));
        var _cy = round(y + lengthdir_y(cleaver_orbit_radius, _a));
        draw_set_color(make_color_rgb(190, 206, 211));
        draw_rectangle(_cx - 7, _cy - 4, _cx + 7, _cy + 3, false);
        draw_set_color(make_color_rgb(91, 57, 38));
        draw_rectangle(_cx - 10, _cy - 2, _cx - 5, _cy + 2, false);
    }
}

draw_set_alpha(1);
draw_set_color(c_white);
