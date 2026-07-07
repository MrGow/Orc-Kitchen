/// oCustomerSpawner — Step Event

if (global.paused) exit;

if (spawned_count >= max_spawned_for_test) exit;

if (global.active_customers >= global.max_customers) exit;

spawn_timer -= 1;

if (spawn_timer > 0) exit;

// ----------------------------------------------------
// Find first available table seat
// ----------------------------------------------------
var _found_table = noone;
var _found_seat = -1;

// Helper search through table instances.
// We search each table object type directly.
var _table_types = [oTableMedium, oTableLarge, oTableSmall];

for (var t = 0; t < array_length(_table_types); t++)
{
    var _obj = _table_types[t];

    if (!object_exists(_obj)) continue;

    var _count = instance_number(_obj);

    for (var n = 0; n < _count; n++)
    {
        var _tbl = instance_find(_obj, n);

        if (_tbl == noone) continue;

        for (var i = 0; i < _tbl.seat_count; i++)
        {
            var _free =
                _tbl.seat_customer[i] == noone
                && !_tbl.seat_reserved[i]
                && !_tbl.seat_has_dirty_plate[i]
                && !_tbl.seat_has_food[i];

            if (_free)
            {
                _found_table = _tbl;
                _found_seat = i;
                break;
            }
        }

        if (_found_table != noone) break;
    }

    if (_found_table != noone) break;
}

// ----------------------------------------------------
// Spawn customer if a seat was found
// ----------------------------------------------------
if (_found_table != noone && _found_seat != -1)
{
    // Reserve seat immediately so another customer cannot take it.
    _found_table.seat_reserved[_found_seat] = true;

    var _c = instance_create_depth(x, y, -y, oCustomer);

    _c.target_table = _found_table;
    _c.target_seat = _found_seat;

    _c.sit_x = _found_table.x + _found_table.seat_xoff[_found_seat];
    _c.sit_y = _found_table.y + _found_table.seat_yoff[_found_seat];

    _found_table.seat_customer[_found_seat] = _c;

    global.active_customers += 1;
    global.customers_spawned += 1;

    spawned_count += 1;

    if (debug_spawner)
    {
        show_debug_message(
            "[CustomerSpawner] Spawned customer. Seat: "
            + string(_found_seat)
        );
    }
}
else
{
    if (debug_spawner)
    {
        show_debug_message("[CustomerSpawner] No free table seat found.");
    }
}

spawn_timer = spawn_delay;

