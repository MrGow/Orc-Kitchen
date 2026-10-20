/// oPlayerUpgradeNotice — Step

if (room != Home) exit;

// Consume the pending message only once, and only after Home loads.
if (!notice_active && variable_global_exists("player_upgrade_notice"))
{
    if (!is_undefined(global.player_upgrade_notice))
    {
        notice_data = global.player_upgrade_notice;
        global.player_upgrade_notice = undefined;
        notice_timer = notice_duration;
        notice_active = true;
    }
}

if (notice_active)
{
    if (notice_timer > 0) notice_timer--;
    if (notice_timer <= 0)
    {
        notice_active = false;
        notice_data = undefined;
    }
}
