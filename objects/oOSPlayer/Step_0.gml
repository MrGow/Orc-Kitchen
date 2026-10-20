/// oOSPlayer — Step (FULL REPLACEMENT)

if (room != OrcSurvivorsRoom) exit;

// Damage received from any enemy or projectile.
if (hp < previous_hp)
{
    hit_flash_timer = hit_flash_duration;
    hit_shake_timer = hit_shake_duration;
}
previous_hp = hp;

if (hit_flash_timer > 0) hit_flash_timer--;
if (hit_shake_timer > 0) hit_shake_timer--;

if (hp <= 0)
{
    hp = 0;
    move_x = 0;
    move_y = 0;
    image_speed = 0;
    exit;
}

// Suspend ALL gameplay while selecting a level-up upgrade.
var _controller = noone;
if (instance_exists(oOSController))
{
    _controller = instance_find(oOSController, 0);
    if (_controller.os_state != "playing")
    {
        move_x = 0;
        move_y = 0;
        image_speed = 0;
        exit;
    }
}

// Check for XP thresholds, including surplus XP already earned.
if (xp >= xp_next && _controller != noone)
{
    xp -= xp_next;
    level += 1;
    xp_next = 5 + (level - 1) * 4;
    _controller.open_level_up();
    move_x = 0;
    move_y = 0;
    image_speed = 0;
    exit;
}

// Movement: WASD or arrow keys.
move_x = 0;
move_y = 0;
if (keyboard_check(ord("A")) || keyboard_check(vk_left)) move_x -= 1;
if (keyboard_check(ord("D")) || keyboard_check(vk_right)) move_x += 1;
if (keyboard_check(ord("W")) || keyboard_check(vk_up)) move_y -= 1;
if (keyboard_check(ord("S")) || keyboard_check(vk_down)) move_y += 1;

var _len = point_distance(0, 0, move_x, move_y);
if (_len > 0)
{
    move_x /= _len;
    move_y /= _len;
}

x = clamp(x + move_x * move_speed, edge_margin, max(edge_margin, room_width - edge_margin));
y = clamp(y + move_y * move_speed, edge_margin, max(edge_margin, room_height - edge_margin));

if (move_x < 0) facing = -1;
else if (move_x > 0) facing = 1;
image_xscale = facing;

if (move_x != 0 || move_y != 0) image_speed = walk_animation_speed;
else
{
    image_speed = 0;
    image_index = 0;
}

if (invulnerability_timer > 0) invulnerability_timer--;

// ====================================================
// AUTOMATIC AXE SWIPE
// ====================================================
if (axe_active_timer > 0) axe_active_timer--;
if (axe_cooldown_timer > 0) axe_cooldown_timer--;

if (axe_cooldown_timer <= 0)
{
    // Aim at nearest Elf in range, or swing toward current facing.
    axe_angle = (facing == 1) ? 0 : 180;
    var _nearest = instance_nearest(x, y, oOSEnemy);
    if (instance_exists(_nearest))
    {
        if (point_distance(x, y, _nearest.x, _nearest.y) <= axe_range + 90)
        {
            axe_angle = point_direction(x, y, _nearest.x, _nearest.y);
        }
    }

    axe_swing_id++;
    axe_active_timer = axe_active_duration;
    axe_cooldown_timer = axe_cooldown;
}

// Hit each enemy once per swipe (do not need collision masks).
if (axe_active_timer > 0)
{
    var _player = id;
    with (oOSEnemy)
    {
        if (hp > 0 && last_axe_swing_id != _player.axe_swing_id)
        {
            var _dist = point_distance(x, y, _player.x, _player.y);
            if (_dist <= _player.axe_range)
            {
                var _toward = point_direction(_player.x, _player.y, x, y);
                if (abs(angle_difference(_toward, _player.axe_angle)) <= _player.axe_arc * 0.5)
                {
                    last_axe_swing_id = _player.axe_swing_id;
                    hp -= _player.axe_damage;
                    hit_flash_timer = hit_flash_duration;
                    knockback_x += lengthdir_x(3.8, _toward);
                    knockback_y += lengthdir_y(3.8, _toward);
                }
            }
        }
    }
}

// ====================================================
// ORBITING CLEAVERS (only after purchasing level-up)
// ====================================================
cleaver_rotation += cleaver_rotation_speed;
if (cleaver_rotation >= 360) cleaver_rotation -= 360;

if (cleaver_count > 0)
{
    var _owner = id;
    with (oOSEnemy)
    {
        if (hp > 0 && cleaver_hit_timer <= 0)
        {
            for (var _i = 0; _i < _owner.cleaver_count; _i++)
            {
                var _ang = _owner.cleaver_rotation + _i * 360 / _owner.cleaver_count;
                var _bx = _owner.x + lengthdir_x(_owner.cleaver_orbit_radius, _ang);
                var _by = _owner.y + lengthdir_y(_owner.cleaver_orbit_radius, _ang);
                if (point_distance(x, y, _bx, _by) <= _owner.cleaver_hit_radius + 9)
                {
                    hp -= _owner.cleaver_damage;
                    hit_flash_timer = hit_flash_duration;
                    cleaver_hit_timer = max(1, round(room_speed * 0.30));
                    var _push = point_direction(_owner.x, _owner.y, x, y);
                    knockback_x += lengthdir_x(2.2, _push);
                    knockback_y += lengthdir_y(2.2, _push);
                    break;
                }
            }
        }
    }
}
