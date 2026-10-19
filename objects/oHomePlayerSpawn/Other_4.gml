/// oHomePlayerSpawn — Room Start
// Place ONE marker in Home.
// This determines where the player enters.
// No sprite or collision mask is required.

if (room != Home)
{
    exit;
}

// Spawn the player only if one does not exist.
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
            "[Home] Player spawned at "
            + string(x)
            + ", "
            + string(y)
        );
    }
}
else
{
    if (global.ok_debug)
    {
        show_debug_message(
            "[Home] Existing oPlayer found; "
            + "spawn marker skipped."
        );
    }
}