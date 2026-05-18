/// oStationPrepCounter — User Event 0
// Called by oPlayer interaction

var _p = interactor;
if (_p == noone || !instance_exists(_p)) exit;

// ----------------------------------------------------
// If counter is empty and player has a clean plate, place it down
// ----------------------------------------------------
if (!has_plate)
{
    if (_p.held_kind == "plate_clean")
    {
        has_plate = true;

        plate_kind   = _p.held_kind;
        plate_sprite = _p.held_sprite;
        plate_name   = _p.held_name;
        plate_data   = _p.held_data;

        _p.held_kind   = "";
        _p.held_sprite = -1;
        _p.held_name   = "";
        _p.held_data   = undefined;
        _p.is_carrying = false;
    }

    exit;
}

// ----------------------------------------------------
// If counter has plate and player is empty-handed, pick it up
// ----------------------------------------------------
if (has_plate && _p.held_kind == "")
{
    _p.held_kind   = plate_kind;
    _p.held_sprite = plate_sprite;
    _p.held_name   = plate_name;
    _p.held_data   = plate_data;
    _p.is_carrying = true;

    has_plate = false;
    plate_kind = "";
    plate_sprite = -1;
    plate_name = "";
    plate_data = undefined;

    exit;
}