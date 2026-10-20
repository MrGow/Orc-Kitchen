/// oOSCamera — Step

// ====================================================
// ROOM SAFETY
// ====================================================

if (room != OrcSurvivorsRoom)
{
    exit;
}


// ====================================================
// FIND TARGET
// ====================================================

if (!instance_exists(target))
{
    if (instance_exists(oOSPlayer))
    {
        target = instance_find(
            oOSPlayer,
            0
        );
    }
    else
    {
        exit;
    }
}


// ====================================================
// CAMERA SAFETY
// ====================================================

if (cam == -1)
{
    exit;
}


// ====================================================
// DESIRED CAMERA POSITION
// ====================================================

var _desired_x =
    target.x - camera_width * 0.5;

var _desired_y =
    target.y - camera_height * 0.5;


// ====================================================
// ROOM BOUNDARIES
// ====================================================

var _max_x = max(
    0,
    room_width - camera_width
);

var _max_y = max(
    0,
    room_height - camera_height
);

_desired_x = clamp(
    _desired_x,
    0,
    _max_x
);

_desired_y = clamp(
    _desired_y,
    0,
    _max_y
);


// ====================================================
// INITIALISE SMOOTH FOLLOW COORDINATES
// ====================================================

// Store the true camera position separately.
//
// Never interpolate from the shaken camera position,
// otherwise shake offsets can accumulate.

if (!variable_instance_exists(id, "follow_x"))
{
    follow_x = camera_get_view_x(cam);
}

if (!variable_instance_exists(id, "follow_y"))
{
    follow_y = camera_get_view_y(cam);
}


// ====================================================
// INITIAL SNAP
// ====================================================

if (!camera_initialised)
{
    follow_x = _desired_x;
    follow_y = _desired_y;

    camera_initialised = true;
}


// ====================================================
// SMOOTH CAMERA FOLLOW
// ====================================================

follow_x = lerp(
    follow_x,
    _desired_x,
    follow_speed
);

follow_y = lerp(
    follow_y,
    _desired_y,
    follow_speed
);


// ====================================================
// SCREEN SHAKE
// ====================================================

var _shake_x = 0;
var _shake_y = 0;

if (instance_exists(target))
{
    if (variable_instance_exists(
        target,
        "hit_shake_timer"
    ))
    {
        if (target.hit_shake_timer > 0)
        {
            // ----------------------------------------
            // SHAKE INTENSITY
            // ----------------------------------------

            var _fraction = clamp(
                target.hit_shake_timer
                / max(1, target.hit_shake_duration),
                0,
                1
            );

            // Strong at the start, fades naturally.
            var _strength =
                target.hit_shake_strength
                * _fraction;


            // ----------------------------------------
            // RANDOM OFFSETS
            // ----------------------------------------

            _shake_x = random_range(
                -_strength,
                _strength
            );

            _shake_y = random_range(
                -_strength,
                _strength
            );
        }
    }
}


// ====================================================
// APPLY SHAKE TO CAMERA
// ====================================================

var _final_x = follow_x + _shake_x;
var _final_y = follow_y + _shake_y;


// ====================================================
// CLAMP FINAL POSITION
// ====================================================

// Camera shake should not expose the area
// outside our 2048x2048 arena.

_final_x = clamp(
    _final_x,
    0,
    _max_x
);

_final_y = clamp(
    _final_y,
    0,
    _max_y
);


// ====================================================
// SET CAMERA POSITION
// ====================================================

camera_set_view_pos(
    cam,
    round(_final_x),
    round(_final_y)
);