/// oOSController — Create (FULL REPLACEMENT)

if (instance_number(oOSController) > 1)
{
    instance_destroy();
    exit;
}

scr_player_upgrades_init();

// Timed waves 1-10. Each wave is 45 seconds of ACTIVE gameplay.
os_state = "playing";
waves_per_evening = 10;
// Current prototype always tests waves 1-10 until the first block is cleared.
// Later sessions (11-20 etc.) will be added separately.
session_start_wave = 1;
session_waves_completed = 0;
session_wave_limit = min(global.os_max_wave, session_start_wave + waves_per_evening - 1);
current_wave = 1;
wave_duration = round(room_speed * 45); // 45s x 10 = 7m30s
wave_timer = wave_duration;
boss_spawned = false;
boss_id = noone;
boss_name = "Fat Disgusting Weak Puny Elf";
victory_duration = round(room_speed * 3);
victory_timer = 0;
// Retry starts from Wave 1 while only first ten waves are implemented.
// Completing the boss banks Wave 11 as the next checkpoint.
max_wave = global.os_max_wave;
campaign_complete = global.os_completed;

// Spawning
enemy_spawn_timer = 0;
enemy_spawn_interval = max(1, round(room_speed * 1.0));
max_active_enemies = 40;
// Wave-dependent cap and spawn speed are calculated in Step.
spawn_margin = 28;
initial_enemy_count = 6;
initial_enemies_spawned = false;
enemies_spawned_session = 0;

// Defeat presentation
defeat_timer = 0;
defeat_duration = room_speed * 3;

// Upgrade UI
upgrade_selected = 0;
upgrade_choices = [];

// Curated tiny upgrade pool. Rarity controls selection weight.
// Names and descriptions fit a 640x360 GUI.
upgrade_pool = [
    { key: "axe_damage", name: "SHARPER AXE", desc: "+1 swipe damage", rarity: "NORMAL", weight: 30 },
    { key: "move_speed", name: "QUICK BOOTS", desc: "+0.3 movement speed", rarity: "NORMAL", weight: 30 },
    { key: "pickup", name: "GREEDY HANDS", desc: "+14 XP pickup radius", rarity: "NORMAL", weight: 26 },
    { key: "axe_range", name: "HUGE SWING", desc: "+17 axe reach", rarity: "MAGIC", weight: 15 },
    { key: "axe_speed", name: "FRENZY", desc: "15% faster axe cooldown", rarity: "MAGIC", weight: 15 },
    { key: "toughness", name: "HARD AS IRON", desc: "+20 max HP; heal 20", rarity: "MAGIC", weight: 15 },
    { key: "cleaver", name: "ORBITING CLEAVER", desc: "Add a spinning cleaver", rarity: "RARE", weight: 7 }
];

// Generate three different weighted upgrade offers.
open_level_up = function()
{
    os_state = "level_up";
    upgrade_selected = 0;
    upgrade_choices = [];
    var _used = [];

    for (var _slot = 0; _slot < 3; _slot++)
    {
        var _total = 0;
        for (var _i = 0; _i < array_length(upgrade_pool); _i++)
        {
            var _eligible = true;
            for (var _j = 0; _j < array_length(_used); _j++)
                if (_used[_j] == _i) _eligible = false;
            if (_eligible) _total += upgrade_pool[_i].weight;
        }

        var _roll = random(_total);
        var _chosen = -1;
        for (var _k = 0; _k < array_length(upgrade_pool); _k++)
        {
            var _already = false;
            for (var _n = 0; _n < array_length(_used); _n++)
                if (_used[_n] == _k) _already = true;
            if (_already) continue;
            _roll -= upgrade_pool[_k].weight;
            if (_roll < 0)
            {
                _chosen = _k;
                break;
            }
        }
        if (_chosen < 0) _chosen = 0;
        array_push(_used, _chosen);
        array_push(upgrade_choices, upgrade_pool[_chosen]);
    }
};

apply_upgrade = function(_index)
{
    if (_index < 0 || _index >= array_length(upgrade_choices)) return;
    if (!instance_exists(oOSPlayer)) return;
    var _p = instance_find(oOSPlayer, 0);
    var _key = upgrade_choices[_index].key;
    switch (_key)
    {
        case "axe_damage": _p.axe_damage += 1; break;
        case "move_speed": _p.move_speed += 0.3; break;
        case "pickup": _p.xp_pickup_radius += 14; break;
        case "axe_range": _p.axe_range += 17; break;
        case "axe_speed":
            _p.axe_cooldown = max(12, round(_p.axe_cooldown * 0.85));
            _p.axe_cooldown_timer = min(_p.axe_cooldown_timer, _p.axe_cooldown);
            break;
        case "toughness":
            _p.max_hp += 20;
            _p.hp = min(_p.max_hp, _p.hp + 20);
            _p.previous_hp = _p.hp;
            break;
        case "cleaver": _p.cleaver_count = min(5, _p.cleaver_count + 1); break;
    }
    os_state = "playing";
    upgrade_choices = [];
};

global.game_state = "orc_survivors";
global.day_phase = "orc_survivors";
global.player_can_move = false;
global.player_can_interact = false;
global.recipe_menu_open = false;
global.paused = false;
depth = -10000;

show_debug_message("[Orc Survivors] Starting combat & XP prototype.");
