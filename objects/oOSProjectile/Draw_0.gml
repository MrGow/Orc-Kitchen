/// oOSProjectile — Draw

// ====================================================
// PROJECTILE POSITION
// ====================================================

var _dx = round(x);
var _dy = round(y);


// ====================================================
// TRAIL
// ====================================================

var _trail_x = x - vx * 3;
var _trail_y = y - vy * 3;

draw_set_alpha(0.25);
draw_set_color(projectile_color);

draw_line_width(
    _dx,
    _dy,
    _trail_x,
    _trail_y,
    5
);


// ====================================================
// OUTER PROJECTILE
// ====================================================

draw_set_alpha(0.45);

draw_set_color(
    projectile_color
);

draw_circle(
    _dx,
    _dy,
    projectile_radius + 2,
    false
);


// ====================================================
// MAIN BODY
// ====================================================

draw_set_alpha(1);

draw_circle(
    _dx,
    _dy,
    projectile_radius,
    false
);


// ====================================================
// CORE
// ====================================================

draw_set_color(
    projectile_core_color
);

draw_circle(
    _dx,
    _dy,
    2,
    false
);


// ====================================================
// RESTORE
// ====================================================

draw_set_alpha(1);
draw_set_color(c_white);