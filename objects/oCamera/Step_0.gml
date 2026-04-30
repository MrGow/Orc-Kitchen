/// oCamera — Step Event
// Smooth follow + room clamp

// ----------------------------------------------------
// Re-acquire player if needed
// ----------------------------------------------------
if (target == noone || !instance_exists(target))
{
    if (instance_exists(oPlayer))
    {
        target = instance_find(oPlayer, 0);
        snap_on_start = true;
    }
}

// ----------------------------------------------------
// No target fallback
// ----------------------------------------------------
if (target == noone)
{
    camera_set_view_pos(cam, round(cam_x), round(cam_y));
    exit;
}

// ----------------------------------------------------
// Current camera centre
// ----------------------------------------------------
var _cam_cx = cam_x + cam_w * 0.5;
var _cam_cy = cam_y + cam_h * 0.5;

// Target desired camera centre
var _target_cx = _cam_cx;
var _target_cy = _cam_cy;

// ----------------------------------------------------
// Deadzone follow
// ----------------------------------------------------
var _dz_l = _cam_cx - deadzone_w * 0.5;
var _dz_r = _cam_cx + deadzone_w * 0.5;
var _dz_t = _cam_cy - deadzone_h * 0.5;
var _dz_b = _cam_cy + deadzone_h * 0.5;

if (target.x < _dz_l)
{
    _target_cx = target.x + deadzone_w * 0.5;
}
else if (target.x > _dz_r)
{
    _target_cx = target.x - deadzone_w * 0.5;
}

if (target.y < _dz_t)
{
    _target_cy = target.y + deadzone_h * 0.5;
}
else if (target.y > _dz_b)
{
    _target_cy = target.y - deadzone_h * 0.5;
}

// Desired top-left camera position
var _desired_x = _target_cx - cam_w * 0.5;
var _desired_y = _target_cy - cam_h * 0.5;

// Clamp desired position to room
_desired_x = clamp(_desired_x, 0, max(0, room_width  - cam_w));
_desired_y = clamp(_desired_y, 0, max(0, room_height - cam_h));

// ----------------------------------------------------
// Snap on first frame / after room change
// ----------------------------------------------------
if (snap_on_start)
{
    cam_x = _desired_x;
    cam_y = _desired_y;
    snap_on_start = false;
}
else
{
    cam_x = lerp(cam_x, _desired_x, follow_smooth);
    cam_y = lerp(cam_y, _desired_y, follow_smooth);
}

// Pixel snap
cam_x = round(cam_x);
cam_y = round(cam_y);

// Apply camera
camera_set_view_pos(cam, cam_x, cam_y);

// ----------------------------------------------------
// Publish globals
// ----------------------------------------------------
global.cam = cam;
global.cam_w = cam_w;
global.cam_h = cam_h;
global.cam_x = cam_x;
global.cam_y = cam_y;