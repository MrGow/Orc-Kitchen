/// oOSProjectile — Step (FULL REPLACEMENT)

if (room != OrcSurvivorsRoom)
{
    instance_destroy();
    exit;
}
if (instance_exists(oOSController))
{
    if (oOSController.os_state != "playing") exit;
}

life_timer--;
if (life_timer <= 0)
{
    instance_destroy();
    exit;
}
x += vx;
y += vy;
animation_timer++;
rotation_angle += rotation_speed;
if (x < -16 || x > room_width + 16 || y < -16 || y > room_height + 16)
{
    instance_destroy();
    exit;
}
if (!instance_exists(oOSPlayer)) exit;
var _p = instance_find(oOSPlayer, 0);
if (point_distance(x, y, _p.x, _p.y) <= hit_radius + 8)
{
    if (_p.invulnerability_timer <= 0)
    {
        _p.hp = max(0, _p.hp - damage);
        _p.invulnerability_timer = max(1, round(room_speed * 0.7));
    }
    instance_destroy();
    exit;
}
