/// oCentralPlazaSpawn — Room Start

// ====================================================
// ROOM CHECK
// ====================================================

if (room != CentralPlaza)
{
    exit;
}


// ====================================================
// SPAWN PLAYER
// ====================================================

if (instance_number(oPlayer) == 0)
{
    var _p = instance_create_depth(
        x,
        y,
        -y,
        oPlayer
    );

    _p.x = x;
    _p.y = y;
    _p.depth = -_p.y;

    if (global.ok_debug)
    {
        show_debug_message(
            "[CentralPlaza] Player spawned at "
            + string(x)
            + ", "
            + string(y)
        );
    }
}
else if (global.ok_debug)
{
    show_debug_message(
        "[CentralPlaza] Existing oPlayer found; "
        + "spawn marker skipped."
    );
}