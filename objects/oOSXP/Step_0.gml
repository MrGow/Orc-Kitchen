/// oOSXP — Step (NEW OBJECT)

if (room != OrcSurvivorsRoom) exit;
if (!instance_exists(oOSController)) exit;
if (oOSController.os_state != "playing") exit;
if (!instance_exists(oOSPlayer)) exit;

var _p = instance_find(oOSPlayer, 0);
var _distance = point_distance(x, y, _p.x, _p.y);
if (_distance <= _p.xp_pickup_radius)
{
    _p.xp += xp_value;
    instance_destroy();
    exit;
}
if (_distance < magnet_range)
{
    var _dir = point_direction(x, y, _p.x, _p.y);
    x += lengthdir_x(pickup_speed, _dir);
    y += lengthdir_y(pickup_speed, _dir);
}
bob_clock++;
depth = -y - 1;
