/// oOSEnemy — Step (FULL REPLACEMENT)

if (room != OrcSurvivorsRoom) exit;

// Freeze combat during upgrade selection and game-over.
if (instance_exists(oOSController))
{
    if (oOSController.os_state != "playing") exit;
}

if (!instance_exists(target))
{
    if (instance_exists(oOSPlayer)) target = instance_find(oOSPlayer, 0);
    else exit;
}

animation_timer++;
if (hit_flash_timer > 0) hit_flash_timer--;
if (cleaver_hit_timer > 0) cleaver_hit_timer--;

// Only drop XP after a real kill; no XP is created when
// the controller clears enemies after player defeat.
if (hp <= 0)
{
    var _orb = instance_create_depth(x, y, -y - 1, oOSXP);
    _orb.xp_value = xp_value;
    instance_destroy();
    exit;
}

var _dx = target.x - x;
var _dy = target.y - y;
var _distance = point_distance(0, 0, _dx, _dy);
var _dir_x = 0;
var _dir_y = 0;
if (_distance > 0.001)
{
    _dir_x = _dx / _distance;
    _dir_y = _dy / _distance;
}

if (_dx < -1) facing = -1;
else if (_dx > 1) facing = 1;
image_xscale = facing;

var _move_x = 0;
var _move_y = 0;
if (enemy_type == "trash" || enemy_type == "fast")
{
    _move_x = _dir_x * move_speed;
    _move_y = _dir_y * move_speed;
}
else if (enemy_type == "ranged" || enemy_type == "boss")
{
    if (_distance > preferred_distance + 25)
    {
        _move_x = _dir_x * move_speed;
        _move_y = _dir_y * move_speed;
    }
    else if (_distance < preferred_distance - 25)
    {
        _move_x = -_dir_x * move_speed;
        _move_y = -_dir_y * move_speed;
    }

    if (attack_timer > 0) attack_timer--;
    if (_distance <= attack_range && attack_timer <= 0)
    {
        var _angle = point_direction(x, y, target.x, target.y);
        var _px = x + lengthdir_x(13, _angle);
        var _py = y + lengthdir_y(13, _angle);
        var _shot = instance_create_depth(_px, _py, -_py - 1, oOSProjectile);
        _shot.configure_projectile(_angle, projectile_speed, projectile_damage, "magic");
        attack_timer = attack_cooldown;
    }
}

// Boss special: a rotating radial volley of magical projectiles.
// Every volley shifts angle, so gaps do not always line up.
if (is_boss)
{
    if (radial_timer > 0) radial_timer--;
    if (radial_timer <= 0)
    {
        for (var _s = 0; _s < radial_bullets; _s++)
        {
            var _a = radial_rotation + _s * (360 / radial_bullets);
            var _ox = x + lengthdir_x(20, _a);
            var _oy = y + lengthdir_y(20, _a);
            var _shot = instance_create_depth(_ox, _oy, -_oy - 1, oOSProjectile);
            _shot.configure_projectile(_a, projectile_speed, projectile_damage, "magic");
        }
        radial_rotation += 11;
        radial_timer = radial_interval;
    }
}

_move_x += knockback_x;
_move_y += knockback_y;
knockback_x *= knockback_friction;
knockback_y *= knockback_friction;
if (abs(knockback_x) < 0.01) knockback_x = 0;
if (abs(knockback_y) < 0.01) knockback_y = 0;

x = clamp(x + _move_x, 8, room_width - 8);
y = clamp(y + _move_y, 8, room_height - 8);
depth = -y;

if (point_distance(x, y, target.x, target.y) <= contact_range)
{
    if (target.invulnerability_timer <= 0)
    {
        target.hp = max(0, target.hp - contact_damage);
        target.invulnerability_timer = contact_invulnerability_frames;
        var _push = point_direction(x, y, target.x, target.y);
        target.x = clamp(target.x + lengthdir_x(5, _push), target.edge_margin, room_width - target.edge_margin);
        target.y = clamp(target.y + lengthdir_y(5, _push), target.edge_margin, room_height - target.edge_margin);
    }
}
