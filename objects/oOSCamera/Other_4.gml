/// oOSCamera — Room Start

// ====================================================
// ROOM SAFETY
// ====================================================

if (room != OrcSurvivorsRoom)
{
    exit;
}


// ====================================================
// ENSURE VIEW IS ENABLED
// ====================================================

view_enabled = true;
view_visible[0] = true;


// ====================================================
// FIND PLAYER
// ====================================================

if (instance_exists(oOSPlayer))
{
    target = instance_find(oOSPlayer, 0);
}
else
{
    target = noone;
}


// ====================================================
// INITIAL CAMERA POSITION
// ====================================================

if (target != noone)
{
    var _max_x = max(
        0,
        room_width - camera_width
    );

    var _max_y = max(
        0,
        room_height - camera_height
    );

    var _cam_x = clamp(
        target.x - camera_width * 0.5,
        0,
        _max_x
    );

    var _cam_y = clamp(
        target.y - camera_height * 0.5,
        0,
        _max_y
    );

    camera_set_view_pos(
        cam,
        round(_cam_x),
        round(_cam_y)
    );

    camera_initialised = true;
}