/// oMarketPlayerSpawn — Room Start Event
// Put ONE marker in Market at the desired player entrance.
// A marker sprite is optional. Do not make this object solid.

if (room != Market) exit;

if (instance_number(oPlayer) == 0)
{
    var _p = instance_create_depth(x, y, -y, oPlayer);
    _p.x = x;
    _p.y = y;
    _p.depth = -_p.y;

    if (global.ok_debug)
        show_debug_message("[Market] Player spawned at " + string(x) + ", " + string(y));
}
else if (global.ok_debug)
{
    show_debug_message("[Market] Existing oPlayer found; spawn marker skipped.");
}
