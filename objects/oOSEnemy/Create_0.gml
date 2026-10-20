/// oOSEnemy — Create (FULL REPLACEMENT)

enemy_type = "trash";
max_hp = 3;
hp = max_hp;
move_speed = random_range(0.8, 1.2);
contact_damage = 10;
contact_range = 15;
xp_value = 1;
target = noone;
facing = 1;
knockback_x = 0;
knockback_y = 0;
knockback_friction = 0.82;
hit_flash_timer = 0;
hit_flash_duration = 7;
contact_invulnerability_frames = max(1, round(room_speed * 0.7));
bob_phase = random(6.28318);
bob_speed = random_range(0.075, 0.11);
bob_amount = random_range(1, 2);
animation_timer = random(1000);
image_speed = 0;
preferred_distance = 135;
attack_range = 235;
attack_timer = 0;
attack_cooldown = 0;
projectile_speed = 2.6;
projectile_damage = 8;
image_xscale = 1;
image_yscale = 1;
depth = -y;
visible = true;
solid = false;

// Boss state. Normal enemies ignore these values.
is_boss = false;
radial_timer = 0;
radial_interval = 0;
radial_bullets = 12;
radial_rotation = 0;

// Weapon hit bookkeeping.
last_axe_swing_id = -1;
cleaver_hit_timer = 0;

configure_enemy = function(_type)
{
    enemy_type = _type;
    is_boss = (_type == "boss");
    target = noone;
    knockback_x = 0;
    knockback_y = 0;
    attack_timer = 0;
    last_axe_swing_id = -1;
    cleaver_hit_timer = 0;
    var _sprite_name = "";
    switch (enemy_type)
    {
        case "boss":
            max_hp = 260;
            move_speed = 0.73;
            contact_damage = 16;
            contact_range = 22;
            xp_value = 35;
            preferred_distance = 155;
            attack_range = 320;
            attack_cooldown = round(room_speed * 2.6);
            attack_timer = round(room_speed * 1.5);
            radial_interval = round(room_speed * 2.9);
            radial_timer = round(room_speed * 1.8);
            radial_bullets = 14;
            radial_rotation = 0;
            projectile_speed = 2.4;
            projectile_damage = 9;
            bob_amount = 1.3;
            _sprite_name = "sprOSElfBoss";
            break;
        case "trash":
            max_hp = 3;
            move_speed = random_range(0.8, 1.2);
            contact_damage = 10;
            contact_range = 15;
            xp_value = 1;
            bob_amount = 1.5;
            _sprite_name = "sprOSElfTrash";
            break;
        case "fast":
            max_hp = 2;
            move_speed = random_range(1.8, 2.4);
            contact_damage = 6;
            contact_range = 13;
            xp_value = 2;
            bob_amount = 2.5;
            bob_speed = 0.17;
            _sprite_name = "sprOSElfFast";
            break;
        case "ranged":
            max_hp = 3;
            move_speed = random_range(0.7, 0.9);
            contact_damage = 5;
            contact_range = 14;
            xp_value = 3;
            preferred_distance = 135;
            attack_range = 235;
            attack_cooldown = max(1, round(room_speed * 2.2));
            attack_timer = irandom_range(round(room_speed * 0.8), round(room_speed * 2.2));
            projectile_speed = 2.6;
            projectile_damage = 8;
            bob_amount = 2;
            _sprite_name = "sprOSElfRanged";
            break;
        default:
            enemy_type = "trash";
            max_hp = 3;
            move_speed = 1;
            contact_damage = 10;
            contact_range = 15;
            xp_value = 1;
            _sprite_name = "sprOSElfTrash";
            break;
    }
    hp = max_hp;
    var _asset = asset_get_index(_sprite_name);
    sprite_index = (_asset != -1) ? _asset : -1;
    image_speed = 0;
    image_index = 0;
};
