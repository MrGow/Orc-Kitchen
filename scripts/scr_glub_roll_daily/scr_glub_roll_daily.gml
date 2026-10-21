/// scr_glub_roll_daily.gml
function scr_glub_roll_daily()
{
    if (!variable_global_exists("day")) global.day = 1;
    if (!variable_global_exists("glub_roll_day")) global.glub_roll_day = -1;
    if (!variable_global_exists("glub_spawn_id")) global.glub_spawn_id = "";
    if (!variable_global_exists("glub_absent_streak")) global.glub_absent_streak = 0;

    if (global.glub_roll_day == global.day) return;

    // IDs must match markers' spawn_id instance variables in the Room Editor.
    var _market = ["market_crates", "market_alley"];
    var _plaza = ["plaza_graveyard", "plaza_tents", "plaza_campfire"];

    var _roll = irandom(99);
    var _destination = "absent";

    // 50% Market, 35% Plaza, 15% missing.
    // After two absent days, the third is guaranteed present.
    if (global.glub_absent_streak >= 2)
    {
        _destination = (irandom(1) == 0) ? "market" : "plaza";
    }
    else if (_roll < 50) _destination = "market";
    else if (_roll < 85) _destination = "plaza";

    if (_destination == "market")
    {
        global.glub_spawn_id = _market[irandom(array_length(_market) - 1)];
        global.glub_absent_streak = 0;
    }
    else if (_destination == "plaza")
    {
        global.glub_spawn_id = _plaza[irandom(array_length(_plaza) - 1)];
        global.glub_absent_streak = 0;
    }
    else
    {
        global.glub_spawn_id = "";
        global.glub_absent_streak += 1;
    }

    global.glub_roll_day = global.day;
    show_debug_message("[Glub] Day " + string(global.day) + " location: "
        + (global.glub_spawn_id == "" ? "ABSENT" : global.glub_spawn_id));
}
