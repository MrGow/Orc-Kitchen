/// oTableParent — User Event 0
// Called by oPlayer interaction

var _p = interactor;
if (_p == noone || !instance_exists(_p)) exit;

// ----------------------------------------------------
// 1. If player is carrying finished food, serve nearest occupied seat
// ----------------------------------------------------
if (_p.is_carrying && _p.held_is_food)
{
    // Only finished meals can be served.
    if (string_pos("meal_", _p.held_kind) != 1) exit;

    var _best_seat = -1;
    var _best_d = 999999;

    for (var i = 0; i < seat_count; i++)
    {
        var _cust = seat_customer[i];

        if (_cust != noone && instance_exists(_cust))
        {
            if (!seat_has_food[i] && !seat_has_dirty_plate[i])
            {
                var _px = x + plate_xoff[i];
                var _py = y + plate_yoff[i];

                var _d = point_distance(_p.x, _p.y, _px, _py);

                if (_d < _best_d)
                {
                    _best_d = _d;
                    _best_seat = i;
                }
            }
        }
    }

    if (_best_seat == -1) exit;

    // Place food visually at that seat.
    seat_has_food[_best_seat] = true;
    seat_food_sprite[_best_seat] = _p.held_sprite;
    seat_food_kind[_best_seat] = _p.held_kind;
    seat_food_name[_best_seat] = _p.held_name;
    seat_food_data[_best_seat] = _p.held_data;

    // Notify customer.
    var _c = seat_customer[_best_seat];

    if (_c != noone && instance_exists(_c))
    {
        _c.served_kind = _p.held_kind;
        _c.served_name = _p.held_name;
        _c.served_data = _p.held_data;
        _c.served_table = id;
        _c.served_seat = _best_seat;
        _c.state = "served";
    }

    // Clear player hand.
    _p.held_kind = "";
    _p.held_sprite = -1;
    _p.held_image = 0;
    _p.held_name = "";
    _p.held_is_food = false;
    _p.held_is_dirty = false;
    _p.held_is_tool = false;
    _p.held_data = undefined;
    _p.is_carrying = false;

    exit;
}

// ----------------------------------------------------
// 2. If player is empty-handed, pick up nearest dirty plate
// ----------------------------------------------------
if (!_p.is_carrying && _p.held_kind == "")
{
    var _dirty_seat = -1;
    var _dirty_d = 999999;

    for (var j = 0; j < seat_count; j++)
    {
        if (seat_has_dirty_plate[j])
        {
            var _dx = x + plate_xoff[j];
            var _dy = y + plate_yoff[j];

            var _dist = point_distance(_p.x, _p.y, _dx, _dy);

            if (_dist < _dirty_d)
            {
                _dirty_d = _dist;
                _dirty_seat = j;
            }
        }
    }

    if (_dirty_seat != -1)
    {
        seat_has_dirty_plate[_dirty_seat] = false;

        _p.held_kind = "plate_dirty";
        _p.held_sprite = spritePlateRegular;
        _p.held_image = 0;
        _p.held_name = "Dirty Plate";
        _p.held_is_food = false;
        _p.held_is_dirty = true;
        _p.held_is_tool = false;

        _p.held_data = {
            container: "plate_regular",
            clean: false,
            dirty: true
        };

        _p.is_carrying = true;
    }

    exit;
}