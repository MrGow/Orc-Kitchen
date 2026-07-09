/// oCustomerSpawner — Step Event

if (global.paused) exit;

if (spawned_count >= max_spawned_for_test) exit;

// For queue testing, this should be higher than table seats.
// active_customers includes seated + queued customers.
if (global.active_customers >= global.max_customers) exit;

spawn_timer -= 1;
if (spawn_timer > 0) exit;

// ----------------------------------------------------
// Find first available table seat
// ----------------------------------------------------
var _found_table = noone;
var _found_seat = -1;

if (object_exists(oTableParent))
{
    var _table_count = instance_number(oTableParent);

    for (var t = 0; t < _table_count; t++)
    {
        var _tbl = instance_find(oTableParent, t);
        if (_tbl == noone) continue;

        // Future purchase support.
        var _available = true;

        if (variable_instance_exists(_tbl, "available"))
        {
            _available = _tbl.available;
        }

        if (!_available) continue;

        for (var s = 0; s < _tbl.seat_count; s++)
        {
            var _free =
                _tbl.seat_customer[s] == noone
                && !_tbl.seat_reserved[s]
                && !_tbl.seat_has_dirty_plate[s]
                && !_tbl.seat_has_food[s];

            if (_free)
            {
                _found_table = _tbl;
                _found_seat = s;
                break;
            }
        }

        if (_found_table != noone) break;
    }
}

// ----------------------------------------------------
// If no seat, find queue slot
// ----------------------------------------------------
var _found_queue = noone;
var _found_queue_slot = -1;

// Safer than object_exists(oCustomerQueueSpot), because it will not crash
// if the object name is missing or not created yet.
var _queue_obj = asset_get_index("oCustomerQueueSpot");

if (_found_table == noone && _queue_obj != -1)
{
    if (instance_number(_queue_obj) > 0)
    {
        var _queue = instance_find(_queue_obj, 0);

        if (_queue != noone)
        {
            for (var q = 0; q < _queue.slot_count; q++)
            {
                if (_queue.queue_customer[q] == noone)
                {
                    _found_queue = _queue;
                    _found_queue_slot = q;
                    break;
                }
            }
        }
    }
}

// ----------------------------------------------------
// Spawn customer to table
// ----------------------------------------------------
if (_found_table != noone && _found_seat != -1)
{
    _found_table.seat_reserved[_found_seat] = true;

    var _c = instance_create_depth(x, y, -y, oCustomer);

    _c.spawn_x = x;
    _c.spawn_y = y;

    _c.target_table = _found_table;
    _c.target_seat = _found_seat;

    _c.sit_x = _found_table.x + _found_table.seat_xoff[_found_seat];
    _c.sit_y = _found_table.y + _found_table.seat_yoff[_found_seat];

    _c.state = "walking_to_table";

    // Clear route so customer builds fresh table-aware path.
    _c.route_points = [];
    _c.route_index = 0;
    _c.route_side_flip = false;
    _c.stuck_timer = 0;
    _c.last_x = _c.x;
    _c.last_y = _c.y;

    _found_table.seat_customer[_found_seat] = _c;

    global.active_customers += 1;
    global.customers_spawned += 1;

    spawned_count += 1;

    if (debug_spawner)
    {
        show_debug_message("[CustomerSpawner] Spawned customer to table seat " + string(_found_seat));
    }
}

// ----------------------------------------------------
// Spawn customer to queue
// ----------------------------------------------------
else if (_found_queue != noone && _found_queue_slot != -1)
{
    var _cq = instance_create_depth(x, y, -y, oCustomer);

    _cq.spawn_x = x;
    _cq.spawn_y = y;

    _cq.state = "walking_to_queue";

    _cq.target_queue = _found_queue;
    _cq.queue_index = _found_queue_slot;
    _cq.queue_x = _found_queue.x + _found_queue.slot_xoff[_found_queue_slot];
    _cq.queue_y = _found_queue.y + _found_queue.slot_yoff[_found_queue_slot];

    // Queue movement is direct for now; queue should be in open space.
    _cq.route_points = [];
    _cq.route_index = 0;
    _cq.route_side_flip = false;
    _cq.stuck_timer = 0;
    _cq.last_x = _cq.x;
    _cq.last_y = _cq.y;

    _found_queue.queue_customer[_found_queue_slot] = _cq;

    global.active_customers += 1;
    global.customers_spawned += 1;
    global.customer_queue_length += 1;

    spawned_count += 1;

    if (debug_spawner)
    {
        show_debug_message("[CustomerSpawner] Spawned customer to queue slot " + string(_found_queue_slot));
    }
}

// ----------------------------------------------------
// No available seat or queue
// ----------------------------------------------------
else
{
    if (debug_spawner)
    {
        show_debug_message("[CustomerSpawner] No free seat or queue slot.");
    }
}

spawn_timer = spawn_delay;