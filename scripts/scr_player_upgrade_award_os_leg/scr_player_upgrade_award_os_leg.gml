/// scr_player_upgrade_award_os_leg.gml
/// Call ONCE when an Orc Survivors 10-wave boss is defeated.
/// _leg: 1=waves 1-10, 2=waves 11-20, ... 5=waves 41-50.
/// Returns true only on a new award.
function scr_player_upgrade_award_os_leg(_leg)
{
    scr_player_upgrades_init();

    if (_leg < 1 || _leg > 5) return false;

    var _u = global.player_upgrades;
    var _index = _leg - 1;

    if (_u.os_speed_milestones[_index]) return false;

    _u.os_speed_milestones[_index] = true;

    // Recalculate the total from flags rather than adding blindly.
    scr_player_upgrades_init();

    var _total_percent = round(_u.movement_speed_bonus * 100);

    // Shown upon arriving Home after the arcade victory card.
    global.player_upgrade_notice = {
        title: "PERMANENT UPGRADE!",
        message: "ALL THAT GAMING MADE YE QUICKER!",
        reward: "MOVEMENT SPEED +3%",
        total: "TOTAL SPEED BONUS: +" + string(_total_percent) + "%"
    };

    show_debug_message(
        "[Player Upgrades] OS leg " + string(_leg)
        + " cleared. Permanent chef speed bonus: +"
        + string(_total_percent) + "%"
    );

    return true;
}
