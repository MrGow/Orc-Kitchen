/// oSocialNPC — Draw

// ====================================================
// PLACEHOLDER CHARACTER
// ====================================================

var _left = x - npc_width * 0.5;
var _right = x + npc_width * 0.5;

var _top = y - npc_height;
var _bottom = y;


// Shadow.
draw_set_color(c_black);
draw_set_alpha(0.30);

draw_ellipse(
    x - 15,
    y - 5,
    x + 15,
    y + 5,
    false
);

draw_set_alpha(1);


// Character.
draw_set_color(npc_color);

draw_rectangle(
    _left,
    _top,
    _right,
    _bottom,
    false
);


// Outline.
draw_set_color(c_black);

draw_rectangle(
    _left,
    _top,
    _right,
    _bottom,
    true
);


// Name above character.
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);

draw_set_color(c_black);
draw_text(x + 1, _top - 5 + 1, npc_name);

draw_set_color(c_white);
draw_text(x, _top - 5, npc_name);


// Restore.
draw_set_color(c_white);
draw_set_alpha(1);

draw_set_halign(fa_left);
draw_set_valign(fa_top);