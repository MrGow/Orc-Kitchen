/// oTableParent — Create Event

// ----------------------------------------------------
// Table base setup
// Parent for oTableSmall, oTableMedium, oTableLarge
// ----------------------------------------------------

// Future purchase/unlock support.
// If a child or room instance already set this, keep it.
if (!variable_instance_exists(id, "available"))
{
    available = true;
}

// ----------------------------------------------------
// Decide table type / seat count from child object
// ----------------------------------------------------
table_type = "medium";
seat_count = 4;

if (object_index == oTableSmall)
{
    table_type = "small";
    seat_count = 2;
}
else if (object_index == oTableMedium)
{
    table_type = "medium";
    seat_count = 4;
}
else if (object_index == oTableLarge)
{
    table_type = "large";
    seat_count = 6;
}

// ----------------------------------------------------
// Seat arrays
// ----------------------------------------------------
seat_customer = array_create(seat_count, noone);
seat_reserved = array_create(seat_count, false);

seat_xoff = array_create(seat_count, 0);
seat_yoff = array_create(seat_count, 0);

plate_xoff = array_create(seat_count, 0);
plate_yoff = array_create(seat_count, 0);

// IMPORTANT:
// Used by customer routing.
// Top-side seats face "down".
// Bottom-side seats face "up".
seat_facing = array_create(seat_count, "up");

seat_has_food = array_create(seat_count, false);
seat_food_sprite = array_create(seat_count, -1);
seat_food_kind = array_create(seat_count, "");
seat_food_name = array_create(seat_count, "");
seat_food_data = array_create(seat_count, undefined);

seat_has_dirty_plate = array_create(seat_count, false);

// ----------------------------------------------------
// Table dimensions
// Assumes table sprite origin is Middle Bottom.
// ----------------------------------------------------
var _w = sprite_get_width(sprite_index);
var _h = sprite_get_height(sprite_index);

// Visual/service positions.
// These are offsets from the table origin.
var _seat_y_top = -_h - 18;
var _seat_y_bot = 22;

var _plate_y_top = -_h + 34;
var _plate_y_bot = -28;

// ----------------------------------------------------
// Build seats dynamically
// ----------------------------------------------------
// Small: 1 top, 1 bottom
// Medium: 2 top, 2 bottom
// Large: 3 top, 3 bottom
// ----------------------------------------------------
var _per_side = seat_count div 2;

// Horizontal spacing.
var _usable_w = _w - 48;
var _spacing = 0;

if (_per_side > 1)
{
    _spacing = _usable_w / (_per_side - 1);
}

for (var i = 0; i < _per_side; i++)
{
    var _xoff;

    if (_per_side == 1)
    {
        _xoff = 0;
    }
    else
    {
        _xoff = -_usable_w * 0.5 + (_spacing * i);
    }

    // ------------------------------
    // Top-side seats
    // Customer sits above table,
    // facing down toward the table.
    // ------------------------------
    var _top_s = i;

    seat_xoff[_top_s] = _xoff;
    seat_yoff[_top_s] = _seat_y_top;

    plate_xoff[_top_s] = _xoff;
    plate_yoff[_top_s] = _plate_y_top;

    seat_facing[_top_s] = "down";

    // ------------------------------
    // Bottom-side seats
    // Customer sits below table,
    // facing up toward the table.
    // ------------------------------
    var _bot_s = i + _per_side;

    seat_xoff[_bot_s] = _xoff;
    seat_yoff[_bot_s] = _seat_y_bot;

    plate_xoff[_bot_s] = _xoff;
    plate_yoff[_bot_s] = _plate_y_bot;

    seat_facing[_bot_s] = "up";
}

// ----------------------------------------------------
// Economy / payment values
// ----------------------------------------------------
pay_correct = 8;
pay_wrong = 2;
pay_burnt = 3;

// ----------------------------------------------------
// Interaction / debug
// ----------------------------------------------------
interactor = noone;

show_debug_seats = true;

// Depth sorting
depth = -y;