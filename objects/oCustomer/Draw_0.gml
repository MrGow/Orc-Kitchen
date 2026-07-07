/// oCustomer — Draw Event

draw_self();

// ----------------------------------------------------
// Order bubble / reaction bubble
// ----------------------------------------------------
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var _bubble_x = x;
var _bubble_y = y - 58;

// Waiting order
if (state == "seated")
{
    // Bubble background
    draw_set_color(c_black);
    draw_set_alpha(0.65);
    draw_roundrect(_bubble_x - 24, _bubble_y - 24, _bubble_x + 24, _bubble_y + 24, false);
    draw_set_alpha(1);

    // Food icon
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

    if (reaction_text == "GOOD!") draw_set_color(c_lime);
    else draw_set_color(c_red);

    draw_text(_bubble_x, _bubble_y, reaction_text);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);