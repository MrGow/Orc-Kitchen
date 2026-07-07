/// oStationGobbleToad — Step Event

if (global.paused) exit;

depth = -y;

// ----------------------------------------------------
// Gobble animation timer
// ----------------------------------------------------
if (gobble_timer > 0)
{
    gobble_timer -= 1;

    // quick squash/stretch
    var _p = gobble_timer / 12;

    image_xscale = base_xscale * (1 + sin(_p * pi) * 0.12);
    image_yscale = base_yscale * (1 - sin(_p * pi) * 0.08);
}
else
{
    image_xscale = base_xscale;
    image_yscale = base_yscale;
}

// ----------------------------------------------------
// Floating text timer
// ----------------------------------------------------
if (gobble_text_timer > 0)
{
    gobble_text_timer -= 1;
}