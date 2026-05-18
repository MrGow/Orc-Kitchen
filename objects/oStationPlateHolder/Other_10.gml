/// oStationPlateHolder — User Event 0
// Called by oPlayer interaction

var _p = interactor;
if (_p == noone || !instance_exists(_p)) exit;

// ----------------------------------------------------
// If player is empty-handed, grab a clean plate
// ----------------------------------------------------
if (_p.held_kind == "")
{
    if (clean_plates > 0)
    {
        clean_plates -= 1;

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
// If player is carrying a clean plate, return/restock it
// ----------------------------------------------------
if (_p.held_kind == "plate_clean")
{
    if (clean_plates < max_clean_plates)
    {
        clean_plates += 1;

        _p.held_kind   = "";
        _p.held_sprite = -1;
        _p.held_name   = "";
        _p.held_data   = undefined;
        _p.is_carrying = false;
    }

    exit;
}