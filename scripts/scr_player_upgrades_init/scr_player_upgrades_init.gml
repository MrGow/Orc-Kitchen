/// scr_player_upgrades_init.gml
/// Initialise once per campaign. Does NOT reset existing upgrades.
function scr_player_upgrades_init()
{
    if (!variable_global_exists("player_upgrades"))
    {
        global.player_upgrades = {
            os_speed_milestones: [false, false, false, false, false],
            movement_speed_bonus: 0,
            stop_fights_unlocked: false,
            shovel_defence_unlocked: false,
            equipped_weapon: ""
        };
    }

    // Reserve an optional notification for our Home overlay.
    if (!variable_global_exists("player_upgrade_notice"))
    {
        global.player_upgrade_notice = undefined;
    }

    // Backfill fields when an older structure lacks them.
    var _u = global.player_upgrades;

    if (!variable_struct_exists(_u, "os_speed_milestones"))
        _u.os_speed_milestones = [false, false, false, false, false];
    if (!variable_struct_exists(_u, "movement_speed_bonus"))
        _u.movement_speed_bonus = 0;
    if (!variable_struct_exists(_u, "stop_fights_unlocked"))
        _u.stop_fights_unlocked = false;
    if (!variable_struct_exists(_u, "shovel_defence_unlocked"))
        _u.shovel_defence_unlocked = false;
    if (!variable_struct_exists(_u, "equipped_weapon"))
        _u.equipped_weapon = "";

    // Authoritative total is derived from claimed milestones.
    // Avoids bonus stacking whenever a room is re-entered.
    var _claimed = 0;
    for (var _i = 0; _i < 5; _i++)
    {
        if (_i < array_length(_u.os_speed_milestones))
        {
            if (_u.os_speed_milestones[_i]) _claimed++;
        }
    }
    _u.movement_speed_bonus = _claimed * 0.03;
}
