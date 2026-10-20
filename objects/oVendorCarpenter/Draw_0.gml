/// oVendorCarpenter — Draw Event

// ====================================================
// VENDOR SPRITE
// ====================================================

if (sprite_index != -1)
{
    draw_self();
}


// ====================================================
// PROMPT SAFETY
// ====================================================

if (room != Market || shop_open || global.paused)
{
    exit;
}

if (!instance_exists(oPlayer))
{
    exit;
}

var _p = instance_nearest(x, y, oPlayer);

if (_p == noone)
{
    exit;
}


// ====================================================
// PROXIMITY
// ====================================================

var _near_x = clamp(
    _p.x,
    bbox_left,
    bbox_right
);

var _near_y = clamp(
    _p.y,
    bbox_top,
    bbox_bottom
);

if (point_distance(
    _p.x,
    _p.y,
    _near_x,
    _near_y
) <= interaction_range)
{
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_set_color(c_yellow);

    draw_text(
        round(x),
        round(bbox_top - 22),
        "E - CARPENTER"
    );

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    draw_set_color(c_white);
}