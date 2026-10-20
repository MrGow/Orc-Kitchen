/// oOSCamera — Create

// ====================================================
// CAMERA SETTINGS
// ====================================================

camera_width = 640;
camera_height = 360;

// 1 = instant follow.
// Smaller values create smoother movement.

follow_speed = 0.12;


// ====================================================
// TARGET
// ====================================================

target = noone;


// ====================================================
// CAMERA REFERENCE
// ====================================================

cam = -1;
owns_camera = false;


// ====================================================
// INITIALISATION
// ====================================================

camera_initialised = false;


// ====================================================
// ROOM VIEW
// ====================================================

view_enabled = true;
view_visible[0] = true;

// Use the room's existing camera if available.

cam = view_camera[0];

if (cam == -1)
{
    cam = camera_create_view(
        0,
        0,
        camera_width,
        camera_height,
        0,
        noone,
        -1,
        -1,
        -1,
        -1
    );

    view_camera[0] = cam;
    owns_camera = true;
}

// Ensure the view has the correct dimensions.

camera_set_view_size(
    cam,
    camera_width,
    camera_height
);