/// oCustomerQueueSpot — Step (FULL REPLACEMENT)
/// Compact queue + assign available seats; direct obstacle-aware routing.

if (global.paused) exit;
depth = -y;

for (var c = 0; c < slot_count; c++)
{
    if (queue_customer[c] != noone && !instance_exists(queue_customer[c]))
        queue_customer[c] = noone;
}

// Compact occupied slots toward the front.
for (var a = 0; a < slot_count - 1; a++)
{
    if (queue_customer[a] == noone)
    {
        for (var b = a + 1; b < slot_count; b++)
        {
            if (queue_customer[b] != noone)
            {
                queue_customer[a] = queue_customer[b];
                queue_customer[b] = noone;
                if (instance_exists(queue_customer[a]))
                {
                    var _cust = queue_customer[a];
                    _cust.queue_index = a;
                    _cust.queue_x = x + slot_xoff[a];
                    _cust.queue_y = y + slot_yoff[a];
                    _cust.route_points = [];
                    _cust.route_index = 0;
                    _cust.stuck_timer = 0;
                    _cust.last_x = _cust.x;
                    _cust.last_y = _cust.y;
                    if (_cust.state == "queued") _cust.state = "walking_to_queue";
                }
                break;
            }
        }
    }
}

var _front = queue_customer[0];
if (_front != noone && instance_exists(_front) && _front.state == "queued")
{
    var _found_table = noone;
    var _found_seat = -1;

    if (object_exists(oTableParent))
    {
        var _table_count = instance_number(oTableParent);
        for (var t = 0; t < _table_count; t++)
        {
            var _tbl = instance_find(oTableParent, t);
            if (_tbl == noone) continue;
            if (variable_instance_exists(_tbl, "available") && !_tbl.available) continue;

            for (var s = 0; s < _tbl.seat_count; s++)
            {
                if (_tbl.seat_customer[s] == noone
                    && !_tbl.seat_reserved[s]
                    && !_tbl.seat_has_food[s]
                    && !_tbl.seat_has_dirty_plate[s])
                {
                    _found_table = _tbl;
                    _found_seat = s;
                    break;
                }
            }
            if (_found_table != noone) break;
        }
    }

    if (_found_table != noone && _found_seat != -1)
    {
        // Book the seat before removing the customer from the queue.
        _found_table.seat_reserved[_found_seat] = true;
        _found_table.seat_customer[_found_seat] = _front;

        _front.target_table = _found_table;
        _front.target_seat = _found_seat;
        _front.sit_x = _found_table.x + _found_table.seat_xoff[_found_seat];
        _front.sit_y = _found_table.y + _found_table.seat_yoff[_found_seat];
        _front.target_queue = noone;
        _front.queue_index = -1;
        _front.route_points = [];
        _front.route_index = 0;
        _front.stuck_timer = 0;
        _front.last_x = _front.x;
        _front.last_y = _front.y;

        // No long trip back through the door: route from current
        // queue position straight to reachable seating approach.
        _front.state = "walking_to_table";

        for (var q = 0; q < slot_count - 1; q++)
        {
            queue_customer[q] = queue_customer[q + 1];
            if (queue_customer[q] != noone && instance_exists(queue_customer[q]))
            {
                var _next = queue_customer[q];
                _next.queue_index = q;
                _next.queue_x = x + slot_xoff[q];
                _next.queue_y = y + slot_yoff[q];
                _next.route_points = [];
                _next.route_index = 0;
                _next.stuck_timer = 0;
                _next.last_x = _next.x;
                _next.last_y = _next.y;
                if (_next.state == "queued") _next.state = "walking_to_queue";
            }
        }
        queue_customer[slot_count - 1] = noone;
    }
}
