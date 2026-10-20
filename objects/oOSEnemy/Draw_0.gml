/// oOSEnemy — Draw (FULL REPLACEMENT)

var _bob = sin(animation_timer * bob_speed + bob_phase) * bob_amount;
var _dx = round(x);
var _dy = round(y + _bob);

draw_set_alpha(0.32);
draw_set_color(c_black);
draw_ellipse(x - (is_boss ? 17 : 9), y + 7, x + (is_boss ? 17 : 9), y + 12, false);
draw_set_alpha(1);

if (sprite_index != -1)
{
    var _ys = is_boss ? 2.1 : 1;
    var _xs = is_boss ? 1.45 : 1;
    var _tint = hit_flash_timer > 0 ? make_color_rgb(255, 150, 150) : c_white;
    draw_sprite_ext(sprite_index, floor(image_index), _dx, _dy, facing * _xs, _ys, 0, _tint, 1);
}
else if (is_boss)
{
    // Very tall, imposing Elf placeholder. No external art needed.
    var _robe = hit_flash_timer > 0 ? c_white : make_color_rgb(113, 42, 127);
    var _skin = hit_flash_timer > 0 ? c_white : make_color_rgb(233, 199, 154);
    draw_set_color(_robe);
    draw_rectangle(_dx - 15, _dy - 38, _dx + 15, _dy + 10, false);
    draw_set_color(make_color_rgb(184, 154, 52));
    draw_rectangle(_dx - 15, _dy - 16, _dx + 15, _dy - 12, false);
    draw_set_color(_skin);
    draw_rectangle(_dx - 11, _dy - 62, _dx + 11, _dy - 36, false);
    draw_triangle(_dx - 11, _dy - 54, _dx - 23, _dy - 60, _dx - 11, _dy - 43, false);
    draw_triangle(_dx + 11, _dy - 54, _dx + 23, _dy - 60, _dx + 11, _dy - 43, false);
    draw_set_color(make_color_rgb(247, 224, 103));
    draw_rectangle(_dx - 11, _dy - 66, _dx + 11, _dy - 59, false);
    draw_set_color(c_red);
    draw_rectangle(_dx - 6, _dy - 50, _dx - 3, _dy - 47, false);
    draw_rectangle(_dx + 3, _dy - 50, _dx + 6, _dy - 47, false);
    // Staff with magical orb.
    draw_set_color(make_color_rgb(128, 85, 50));
    draw_line_width(_dx + 22, _dy + 8, _dx + 22, _dy - 52, 4);
    draw_set_color(make_color_rgb(210, 86, 245));
    draw_circle(_dx + 22, _dy - 56, 7, false);
}
else
{
    var _body = make_color_rgb(103, 125, 96);
    var _head = make_color_rgb(224, 185, 145);
    var _hair = make_color_rgb(225, 207, 110);
    if (enemy_type == "fast")
    {
        _body = make_color_rgb(167, 117, 46);
        _head = make_color_rgb(242, 195, 140);
        _hair = make_color_rgb(212, 142, 45);
    }
    else if (enemy_type == "ranged")
    {
        _body = make_color_rgb(112, 63, 151);
        _head = make_color_rgb(215, 182, 165);
        _hair = make_color_rgb(189, 211, 236);
    }
    if (hit_flash_timer > 0) { _body = c_white; _head = c_white; _hair = c_white; }
    draw_set_color(_body);
    draw_rectangle(_dx - 6, _dy - 5, _dx + 6, _dy + 9, false);
    draw_set_color(_head);
    draw_rectangle(_dx - 5, _dy - 13, _dx + 5, _dy - 4, false);
    draw_triangle(_dx - 5, _dy - 10, _dx - 12, _dy - 14, _dx - 5, _dy - 6, false);
    draw_triangle(_dx + 5, _dy - 10, _dx + 12, _dy - 14, _dx + 5, _dy - 6, false);
    draw_set_color(_hair);
    draw_rectangle(_dx - 5, _dy - 14, _dx + 5, _dy - 11, false);
    draw_set_color(enemy_type == "fast" ? c_red : (enemy_type == "ranged" ? c_aqua : c_black));
    draw_rectangle(_dx + facing * 2 - 1, _dy - 9, _dx + facing * 2, _dy - 8, false);
    if (enemy_type == "ranged")
    {
        var _staff_x = _dx + facing * 11;
        draw_set_color(make_color_rgb(112, 77, 43));
        draw_line_width(_staff_x, _dy - 13, _staff_x, _dy + 12, 3);
        draw_set_color(make_color_rgb(195, 95, 255));
        draw_circle(_staff_x, _dy - 15, 4, false);
    }
    else if (enemy_type == "trash")
    {
        draw_set_color(c_silver);
        draw_line_width(_dx + facing * 10, _dy - 3, _dx + facing * 13, _dy - 17, 2);
    }
}

draw_set_alpha(1);
draw_set_color(c_white);
