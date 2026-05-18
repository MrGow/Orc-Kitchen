/// oPlayer — Draw Event
// Draw player and carried item above head

// Draw player sprite
draw_self();

// ----------------------------------------------------
// Draw carried item above head
// ----------------------------------------------------
if (is_carrying && held_sprite != -1)
{
    var _wob_x = 0;
    var _wob_y = 0;

    if (held_wobble_amp > 0)
    {
        _wob_x = sin(held_wobble) * held_wobble_amp;
        _wob_y = cos(held_wobble * 1.25) * held_wobble_amp;
    }

    draw_sprite(
        held_sprite,
        held_image,
        round(x + held_draw_xoff + _wob_x),
        round(y + held_draw_yoff + _wob_y)
    );
}

// ----------------------------------------------------
// Debug feet box / carry info
// ----------------------------------------------------
if (debug_player)
{
    draw_set_alpha(0.45);
    draw_set_color(c_lime);
    draw_rectangle(
        x - feet_half_w,
        y - feet_half_h,
        x + feet_half_w,
        y + feet_half_h,
        false
    );
    draw_set_alpha(1);

    draw_set_color(c_white);
    draw_text(x + 12, y - 48, "Held: " + string(held_name));

    if (target_interact != noone)
    {
        draw_text(x + 12, y - 30, "Target: " + string(target_interact.object_index));
    }
}