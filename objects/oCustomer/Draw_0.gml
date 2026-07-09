/// oCustomer — Draw Event

draw_self();

// ----------------------------------------------------
// Order / queue / reaction bubble
// ----------------------------------------------------
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var _bubble_x = x;
var _bubble_y = y - 58;

// Queued marker
if (state == "queued" || state == "walking_to_queue")
{
    draw_set_color(c_white);
    draw_text(_bubble_x, _bubble_y, "WAIT");
}

// Waiting order
if (state == "seated")
{
    draw_set_color(c_black);
    draw_set_alpha(0.65);
    draw_roundrect(_bubble_x - 24, _bubble_y - 24, _bubble_x + 24, _bubble_y + 24, false);
    draw_set_alpha(1);

    if (order_sprite != -1)
    {
        draw_sprite(order_sprite, 0, _bubble_x, _bubble_y);
    }
}

// Reaction
if (reaction_timer > 0)
{
    draw_set_color(c_black);
    draw_set_alpha(0.65);
    draw_roundrect(_bubble_x - 42, _bubble_y - 14, _bubble_x + 42, _bubble_y + 14, false);
    draw_set_alpha(1);

    if (reaction_text == "GOOD!")
    {
        draw_set_color(c_lime);
    }
    else
    {
        draw_set_color(c_red);
    }

    draw_text(_bubble_x, _bubble_y, reaction_text);
}

// ----------------------------------------------------
// Debug route drawing
// ----------------------------------------------------
if (global.debug_mode)
{
    if (array_length(route_points) > 0)
    {
        draw_set_alpha(0.75);
        draw_set_color(c_aqua);

        var _prev_x = x;
        var _prev_y = y;

        for (var i = route_index; i < array_length(route_points); i++)
        {
            var _pt = route_points[i];

            draw_line(_prev_x, _prev_y, _pt.x, _pt.y);
            draw_circle(_pt.x, _pt.y, 4, false);

            _prev_x = _pt.x;
            _prev_y = _pt.y;
        }

        draw_set_alpha(1);
    }
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);