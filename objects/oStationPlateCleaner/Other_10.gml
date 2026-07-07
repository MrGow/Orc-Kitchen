/// oStationPlateCleaner — User Event 0
// Called by oPlayer interaction

var _p = interactor;
if (_p == noone || !instance_exists(_p)) exit;

// ----------------------------------------------------
// If player has a dirty plate, add it to dirty queue
// ----------------------------------------------------
if (_p.held_kind == "plate_dirty")
{
    if (dirty_queue < dirty_queue_max)
    {
        dirty_queue += 1;

        _p.held_kind    = "";
        _p.held_sprite  = -1;
        _p.held_image   = 0;
        _p.held_name    = "";
        _p.held_is_food = false;
        _p.held_is_dirty = false;
        _p.held_is_tool = false;
        _p.held_data    = undefined;
        _p.is_carrying  = false;
    }

    exit;
}

// ----------------------------------------------------
// If player is empty-handed and clean plate is ready, pick one up
// ----------------------------------------------------
if (_p.held_kind == "" && clean_ready > 0)
{
    clean_ready -= 1;

    _p.held_kind   = "plate_clean";
    _p.held_sprite = spritePlateRegular;
    _p.held_image  = 0;
    _p.held_name   = "Clean Plate";

    _p.held_is_food = false;
    _p.held_is_dirty = false;
    _p.held_is_tool = false;

    _p.held_data = {
        container: "plate_regular",
        clean: true,
        dirty: false,
        components: []
    };

    _p.is_carrying = true;

    exit;
}