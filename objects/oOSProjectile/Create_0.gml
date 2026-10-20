/// oOSProjectile — Create

// ====================================================
// PROJECTILE DATA
// ====================================================

projectile_type = "magic";

travel_angle = 0;
travel_speed = 2.6;

vx = 0;
vy = 0;

damage = 8;

hit_radius = 6;


// ====================================================
// LIFETIME
// ====================================================

life_max = max(
    1,
    round(room_speed * 3.5)
);

life_timer = life_max;


// ====================================================
// ANIMATION
// ====================================================

animation_timer = random(1000);

rotation_speed = 8;

rotation_angle = random(360);


// ====================================================
// APPEARANCE
// ====================================================

projectile_color = make_color_rgb(
    192, 88, 255
);

projectile_core_color = make_color_rgb(
    250, 215, 255
);

projectile_radius = 5;


// ====================================================
// INITIALISATION FUNCTION
// ====================================================

// The enemy calls this immediately after
// creating the projectile.

configure_projectile = function(
    _angle,
    _speed,
    _damage,
    _type
)
{
    travel_angle = _angle;
    travel_speed = _speed;

    damage = _damage;
    projectile_type = _type;

    vx = lengthdir_x(
        travel_speed,
        travel_angle
    );

    vy = lengthdir_y(
        travel_speed,
        travel_angle
    );

    life_timer = life_max;
};


// ====================================================
// OBJECT SETTINGS
// ====================================================

visible = true;
solid = false;

sprite_index = -1;