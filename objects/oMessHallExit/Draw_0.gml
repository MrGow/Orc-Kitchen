/// oMessHallExit — Draw Event

// ----------------------------------------------------
// Debug trigger rectangle
// ----------------------------------------------------
if (global.ok_debug && debug_draw)
{
    draw_set_alpha(0.30);

    if (global.can_leave_mess_hall)
    {
        draw_set_color(c_lime);
    }
    else
    {
        draw_set_color(c_red);
    }

    draw_rectangle(
        bbox_left,
        bbox_top,
        bbox_right,
        bbox_bottom,
        false
    );

    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);

    draw_text(
        (bbox_left + bbox_right) * 0.5,
        bbox_top - 16,
        "MESS HALL EXIT"
    );
}

// ----------------------------------------------------
// Blocked text
// ----------------------------------------------------
if (exit_text_timer > 0)
{
    var _tx = (bbox_left + bbox_right) * 0.5;
    var _ty = bbox_top - 42;

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_set_color(c_black);
    draw_set_alpha(0.70);

    draw_roundrect(
        _tx - 110,
        _ty - 14,
        _tx + 110,
        _ty + 14,
        false
    );

    draw_set_alpha(1);
    draw_set_color(c_white);

    draw_text(
        _tx,
        _ty,
        exit_text
    );
}

// ----------------------------------------------------
// Reset draw state
// ----------------------------------------------------
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_set_color(c_white);