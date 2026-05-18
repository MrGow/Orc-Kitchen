/// oStationPlateCleaner — User Event 0
// Called by oPlayer interaction

var _p = interactor;
if (_p == noone || !instance_exists(_p)) exit;

// ----------------------------------------------------
// If cleaner has clean plate ready and player is empty-handed, pick it up
// ----------------------------------------------------
if (clean_plate_ready)
{
    if (_p.held_kind == "")
    {
        clean_plate_ready = false;

        _p.held_kind   = "plate_clean";
        _p.held_sprite = spritePlateRegular;
        _p.held_name   = "Clean Plate";
        _p.held_data   = {
            container: "plate_regular",
            clean: true,
            dirty: false,
            components: []
        };

        _p.is_carrying = true;
    }

    exit;
}

// ----------------------------------------------------
// If player has a dirty plate, start washing it
// ----------------------------------------------------
if (!washing && _p.held_kind == "plate_dirty")
{
    washing = true;
    wash_progress = 0;

    _p.held_kind   = "";
    _p.held_sprite = -1;
    _p.held_name   = "";
    _p.held_data   = undefined;
    _p.is_carrying = false;

    exit;
}