/// oCustomerSpawner — Step Event
// One randomized, pre-planned schedule per day.
// Does not spawn during countdown, Last Call, or cleanup.

if (room != MessHall) exit;
if (global.paused) exit;
if (global.day_phase != "serving") exit;
if (global.shift_state != "serving") exit;

// Room instances are recreated when re-entering MessHall.
// Restore count from oGame's shift statistics.
if (spawned_count < global.customers_spawned)
    spawned_count = global.customers_spawned;

var _planned_total = array_length(global.day_spawn_times);
if (spawned_count >= _planned_total) exit;
if (spawned_count >= global.day_target_customers) exit;

if (retry_timer > 0)
{
    retry_timer -= 1;
    exit;
}

if (spawn_cooldown > 0)
{
    spawn_cooldown -= 1;
    exit;
}

// Wait until the next scheduled arrival time.
if (global.shift_elapsed < global.day_spawn_times[spawned_count])
    exit;

// Active count includes table customers and queue customers.
if (global.active_customers >= global.max_customers)
{
    retry_timer = retry_delay;
    exit;
}

// ====================================================
// FIRST FREE TABLE SEAT
// ====================================================
var _found_table = noone;
var _found_seat = -1;

if (object_exists(oTableParent))
{
    var _table_count = instance_number(oTableParent);

    for (var t = 0; t < _table_count; t++)
    {
        var _tbl = instance_find(oTableParent, t);
        if (_tbl == noone) continue;

        var _available = true;
        if (variable_instance_exists(_tbl, "available"))
            _available = _tbl.available;

        if (!_available) continue;

        for (var s = 0; s < _tbl.seat_count; s++)
        {
            var _free = _tbl.seat_customer[s] == noone
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

// ====================================================
// IF NO SEAT, FIRST FREE QUEUE SLOT
// ====================================================
var _found_queue = noone;
var _found_queue_slot = -1;
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

// ====================================================
// CREATE CUSTOMER TO TABLE
// ====================================================
var _did_spawn = false;

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

    _c.route_points = [];
    _c.route_index = 0;
    _c.route_side_flip = false;
    _c.stuck_timer = 0;
    _c.last_x = _c.x;
    _c.last_y = _c.y;

    _found_table.seat_customer[_found_seat] = _c;
    _did_spawn = true;

    if (debug_spawner)
        show_debug_message("[CustomerSpawner] Table seat " + string(_found_seat));
}
else if (_found_queue != noone && _found_queue_slot != -1)
{
    // =================================================
    // CREATE CUSTOMER TO QUEUE
    // =================================================
    var _cq = instance_create_depth(x, y, -y, oCustomer);

    _cq.spawn_x = x;
    _cq.spawn_y = y;
    _cq.state = "walking_to_queue";
    _cq.target_queue = _found_queue;
    _cq.queue_index = _found_queue_slot;
    _cq.queue_x = _found_queue.x + _found_queue.slot_xoff[_found_queue_slot];
    _cq.queue_y = _found_queue.y + _found_queue.slot_yoff[_found_queue_slot];

    _cq.route_points = [];
    _cq.route_index = 0;
    _cq.route_side_flip = false;
    _cq.stuck_timer = 0;
    _cq.last_x = _cq.x;
    _cq.last_y = _cq.y;

    _found_queue.queue_customer[_found_queue_slot] = _cq;
    global.customer_queue_length += 1;
    _did_spawn = true;

    if (debug_spawner)
        show_debug_message("[CustomerSpawner] Queue slot " + string(_found_queue_slot));
}

// ====================================================
// COUNT SUCCESS OR RETRY LATER
// ====================================================
if (_did_spawn)
{
    global.active_customers += 1;
    global.customers_spawned += 1;
    spawned_count += 1;
    spawn_cooldown = spawn_cooldown_length;

    if (debug_spawner)
        show_debug_message("[CustomerSpawner] Arrival "
            + string(spawned_count) + "/"
            + string(global.day_target_customers)
            + " (shift t="
            + string_format(global.shift_elapsed / room_speed, 0, 1)
            + "s)");
}
else
{
    // A blocked arrival remains pending. It is NOT lost,
    // but Last Call still stops all pending arrivals.
    retry_timer = retry_delay;

    if (debug_spawner)
        show_debug_message("[CustomerSpawner] All seats and queue full; retrying.");
}
