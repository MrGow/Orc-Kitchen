/// oCamera — Create Event
// Simple top-down camera for Orc Kitchen
// Place one oCamera in each room: Mess Hall, Shop, Home

// ----------------------------------------------------
// Base view size
// ----------------------------------------------------
cam_w = 640;
cam_h = 360;

// ----------------------------------------------------
// Camera follow target
// ----------------------------------------------------
target = noone;

if (instance_exists(oPlayer))
{
    target = instance_find(oPlayer, 0);
}

// ----------------------------------------------------
// Follow settings
// ----------------------------------------------------
follow_smooth = 0.12;
snap_on_start = true;

// Deadzone to stop tiny camera jitter
deadzone_w = 96;
deadzone_h = 56;

// Camera position
cam_x = 0;
cam_y = 0;

// ----------------------------------------------------
// Camera setup
// ----------------------------------------------------
view_enabled = true;
view_visible[0] = true;

// Always create a fresh camera for this room.
// This avoids camera_exists() compatibility issues.
cam = camera_create_view(0, 0, cam_w, cam_h, 0, noone, -1, -1, -1, -1);
view_camera[0] = cam;

camera_set_view_size(cam, cam_w, cam_h);

// Set viewport to current window size.
// This can be replaced later by an integer-scaling oGame.
view_set_wport(0, window_get_width());
view_set_hport(0, window_get_height());

// ----------------------------------------------------
// Initial position
// ----------------------------------------------------
if (target != noone)
{
    cam_x = target.x - cam_w * 0.5;
    cam_y = target.y - cam_h * 0.5;
}
else
{
    cam_x = 0;
    cam_y = 0;
}

// Clamp to room
cam_x = clamp(cam_x, 0, max(0, room_width  - cam_w));
cam_y = clamp(cam_y, 0, max(0, room_height - cam_h));

camera_set_view_pos(cam, round(cam_x), round(cam_y));

// ----------------------------------------------------
// Publish useful globals
// ----------------------------------------------------
global.cam   = cam;
global.cam_w = cam_w;
global.cam_h = cam_h;
global.cam_x = cam_x;
global.cam_y = cam_y;

// ----------------------------------------------------
// Debug
// ----------------------------------------------------
debug_camera = false;