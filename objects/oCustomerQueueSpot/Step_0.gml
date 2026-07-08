/// oCustomerQueueSpot — Step Event

if (global.paused) exit;

depth = -y;

// ----------------------------------------------------
// Clear destroyed customers from queue slots
// ----------------------------------------------------
for (var c = 0; c < slot_count; c++)
{
    if (queue_customer[c] != noone && !instance_exists(queue_customer[c]))
    {
        queue_customer[c] = noone;
    }
}

// ----------------------------------------------------
// Compact queue if there are gaps
// ----------------------------------------------------
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
                    queue_customer[a].queue_index = a;
                    queue_customer[a].queue_x = x + slot_xoff[a];
                    queue_customer[a].queue_y = y + slot_yoff[a];

                    if (queue_customer[a].state == "queued")
                    {
                        queue_customer[a].state = "walking_to_queue";
                    }
                }

                break;
            }
        }
    }
}

// ----------------------------------------------------
// If front customer is queued, try to send them to a free table seat
// ----------------------------------------------------
var _front = queue_customer[0];

if (_front != noone && instance_exists(_front))
{
    if (_front.state == "queued")
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

                // Future purchase support.
                // If table has available=false, queue ignores it.
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
                        && !_tbl.seat_has_food[s]
                        && !_tbl.seat_has_dirty_plate[s];

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

        if (_found_table != noone && _found_seat != -1)
        {
            // Remove front customer from queue and shift everyone forward.
            queue_customer[0] = noone;

            for (var q = 0; q < slot_count - 1; q++)
            {
                queue_customer[q] = queue_customer[q + 1];

                if (queue_customer[q] != noone && instance_exists(queue_customer[q]))
                {
                    queue_customer[q].queue_index = q;
                    queue_customer[q].queue_x = x + slot_xoff[q];
                    queue_customer[q].queue_y = y + slot_yoff[q];

                    if (queue_customer[q].state == "queued")
                    {
                        queue_customer[q].state = "walking_to_queue";
                    }
                }
            }

            queue_customer[slot_count - 1] = noone;

            // Send front customer to table.
            _found_table.seat_reserved[_found_seat] = true;
            _found_table.seat_customer[_found_seat] = _front;

            _front.target_table = _found_table;
            _front.target_seat = _found_seat;

            _front.sit_x = _found_table.x + _found_table.seat_xoff[_found_seat];
            _front.sit_y = _found_table.y + _found_table.seat_yoff[_found_seat];

            _front.target_queue = noone;
            _front.queue_index = -1;

            _front.state = "walking_to_table";
        }
    }
}