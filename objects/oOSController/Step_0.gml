/// oOSController — Step (FULL REPLACEMENT)

if (room != OrcSurvivorsRoom) exit;

// After beating wave 10, show a victory card, then go Home.
if (os_state == "victory")
{
    victory_timer--;
    if (victory_timer <= 0)
    {
        global.evening_activity_used = true;
        global.game_state = "home";
        global.day_phase = "home";
        global.recipe_menu_open = false;
        global.recipe_menu_was_open = false;
        global.paused = false;
        global.player_can_move = false;
        global.player_can_interact = false;
        room_goto(Home);
    }
    exit;
}


// Defeat countdown; Home blocks another arcade session tonight.
if (os_state == "game_over")
{
    defeat_timer--;
    if (defeat_timer <= 0)
    {
        global.evening_activity_used = true;
        global.game_state = "home";
        global.day_phase = "home";
        global.recipe_menu_open = false;
        global.recipe_menu_was_open = false;
        global.paused = false;
        global.player_can_move = false;
        global.player_can_interact = false;
        room_goto(Home);
    }
    exit;
}

// Level-up screen controls. Backspace cannot skip the selection.
if (os_state == "level_up")
{
    if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W")))
        upgrade_selected = max(0, upgrade_selected - 1);
    if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S")))
        upgrade_selected = min(array_length(upgrade_choices) - 1, upgrade_selected + 1);
    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || keyboard_check_pressed(ord("E")))
        apply_upgrade(upgrade_selected);
    exit;
}

if (!instance_exists(oOSPlayer)) exit;
var _player = instance_find(oOSPlayer, 0);

// Detect death BEFORE handling exit or spawning.
if (_player.hp <= 0)
{
    os_state = "game_over";
    defeat_timer = defeat_duration;
    _player.hp = 0;
    global.evening_activity_used = true;
    global.player_can_move = false;
    global.player_can_interact = false;
    with (oOSEnemy) instance_destroy();
    with (oOSProjectile) instance_destroy();
    show_debug_message("[Orc Survivors] DA ELVES CHEATED!");
    exit;
}

// Manual early exit still consumes the evening.
if (keyboard_check_pressed(vk_backspace))
{
    global.evening_activity_used = true;
    global.game_state = "home";
    global.day_phase = "home";
    global.recipe_menu_open = false;
    global.recipe_menu_was_open = false;
    global.paused = false;
    global.player_can_move = false;
    global.player_can_interact = false;
    room_goto(Home);
    exit;
}

// ====================================================
// TIMED WAVES — PAUSE DURING LEVEL-UP / DEFEAT
// ====================================================
if (wave_timer > 0) wave_timer--;

if (wave_timer <= 0 && current_wave < 10)
{
    current_wave++;
    wave_timer = wave_duration;
    enemy_spawn_timer = 1;
    show_debug_message("[Orc Survivors] WAVE " + string(current_wave));
}

// ====================================================
// WAVE TEN BOSS — SPAWN ONCE, JUST OUTSIDE THE PLAYER
// ====================================================
if (current_wave == 10 && !boss_spawned)
{
    boss_spawned = true;
    var _bx = clamp(_player.x + 235, 20, room_width - 20);
    var _by = clamp(_player.y - 90, 20, room_height - 20);
    boss_id = instance_create_depth(_bx, _by, -_by, oOSEnemy);
    boss_id.configure_enemy("boss");
    show_debug_message("[Orc Survivors] BOSS ENTERS: " + boss_name);
}

// Only complete after the 45-second final wave AND boss death.
if (current_wave == 10 && wave_timer <= 0
    && boss_spawned && !instance_exists(boss_id))
{
    os_state = "victory";
    victory_timer = victory_duration;
    global.os_wave = max(global.os_wave, 11);
    // Permanent CHEF reward, not an Orc Survivors run upgrade.
    // Awarded exactly once per 10-wave milestone.
    scr_player_upgrade_award_os_leg(1);
    global.evening_activity_used = true;
    with (oOSEnemy) instance_destroy();
    with (oOSProjectile) instance_destroy();
    with (oOSXP) instance_destroy();
    show_debug_message("[Orc Survivors] Boss down! Waves 1-10 cleared; next wave 11 unlocked.");
    exit;
}

// Slowly scale up enemy population and spawning across ten waves.
max_active_enemies = min(78, 25 + current_wave * 5);
enemy_spawn_interval = max(round(room_speed * 0.27),
    round(room_speed * (1.05 - (current_wave - 1) * 0.075)));

// Spawn timer & population limit.
if (!initial_enemies_spawned)
{
    initial_enemies_spawned = true;
    enemy_spawn_timer = 1;
}
if (enemy_spawn_timer > 0) enemy_spawn_timer--;
if (enemy_spawn_timer > 0) exit;
if (instance_number(oOSEnemy) >= max_active_enemies)
{
    enemy_spawn_timer = 10;
    exit;
}

// Choose a camera-exterior position within the world.
var _cam = view_camera[0];
var _cx = 0;
var _cy = 0;
var _cw = 640;
var _ch = 360;
if (_cam != -1)
{
    _cx = camera_get_view_x(_cam);
    _cy = camera_get_view_y(_cam);
    _cw = camera_get_view_width(_cam);
    _ch = camera_get_view_height(_cam);
}

var _sx = 0;
var _sy = 0;
var _ok = false;
for (var _attempt = 0; _attempt < 12; _attempt++)
{
    switch (irandom(3))
    {
        case 0:
            _sx = random_range(_cx, _cx + _cw);
            _sy = _cy - spawn_margin;
            break;
        case 1:
            _sx = _cx + _cw + spawn_margin;
            _sy = random_range(_cy, _cy + _ch);
            break;
        case 2:
            _sx = random_range(_cx, _cx + _cw);
            _sy = _cy + _ch + spawn_margin;
            break;
        case 3:
            _sx = _cx - spawn_margin;
            _sy = random_range(_cy, _cy + _ch);
            break;
    }
    if (_sx >= 8 && _sx <= room_width - 8 && _sy >= 8 && _sy <= room_height - 8)
    {
        _ok = true;
        break;
    }
}
if (!_ok)
{
    var _angle = random(360);
    _sx = _player.x + lengthdir_x(380, _angle);
    _sy = _player.y + lengthdir_y(380, _angle);
}
_sx = clamp(_sx, 8, room_width - 8);
_sy = clamp(_sy, 8, room_height - 8);

// Early waves favour trash; later waves include more fast and ranged Elves.
var _roll = irandom(99);
var _type = "trash";
if (current_wave <= 2)
{
    _type = "trash";
}
else if (current_wave <= 4)
{
    if (_roll >= 80) _type = "fast";
}
else if (current_wave <= 7)
{
    if (_roll >= 85) _type = "ranged";
    else if (_roll >= 60) _type = "fast";
}
else
{
    if (_roll >= 72) _type = "ranged";
    else if (_roll >= 42) _type = "fast";
}
var _enemy = instance_create_depth(_sx, _sy, -_sy, oOSEnemy);
_enemy.configure_enemy(_type);
enemies_spawned_session++;
enemy_spawn_timer = enemy_spawn_interval;
