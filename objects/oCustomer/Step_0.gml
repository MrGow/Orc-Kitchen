/// oCustomer — Step Event

if (global.paused) exit;

depth = -y;

if (reaction_timer > 0)
{
    reaction_timer -= 1;
}

// ----------------------------------------------------
// Local helper: collision check
// ----------------------------------------------------
function __customer_can_stand_at(_x, _y)
{
    var _old_x = x;
    var _old_y = y;

    x = _x;
    y = _y;

    var _blocked = false;

    if (object_exists(oSolidStation))
    {
        if (place_meeting(x, y, oSolidStation))
        {
            _blocked = true;
        }
    }

    x = _old_x;
    y = _old_y;

    return !_blocked;
}

// ----------------------------------------------------
// Local helper: move with simple collision sliding
// ----------------------------------------------------
function __customer_move_to(_tx, _ty, _spd)
{
    var _d = point_distance(x, y, _tx, _ty);

    if (_d <= 2)
    {
        x = _tx;
        y = _ty;
        return true;
    }

    var _dir = point_direction(x, y, _tx, _ty);

    var _mx = lengthdir_x(_spd, _dir);
    var _my = lengthdir_y(_spd, _dir);

    // Do not overshoot.
    if (abs(_mx) > abs(_tx - x)) _mx = _tx - x;
    if (abs(_my) > abs(_ty - y)) _my = _ty - y;

    // Move X first.
    if (_mx != 0)
    {
        if (__customer_can_stand_at(x + _mx, y))
        {
            x += _mx;
        }
        else
        {
            var _sx = sign(_mx);

            repeat (abs(round(_mx)))
            {
                if (__customer_can_stand_at(x + _sx, y))
                {
                    x += _sx;
                }
                else
                {
                    break;
                }
            }
        }
    }

    // Then move Y.
    if (_my != 0)
    {
        if (__customer_can_stand_at(x, y + _my))
        {
            y += _my;
        }
        else
        {
            var _sy = sign(_my);

            repeat (abs(round(_my)))
            {
                if (__customer_can_stand_at(x, y + _sy))
                {
                    y += _sy;
                }
                else
                {
                    break;
                }
            }
        }
    }

    return false;
}

// ----------------------------------------------------
// Route helpers
// ----------------------------------------------------
function __customer_clear_path()
{
    route_points = [];
    route_index = 0;
}

function __customer_add_path_point(_x, _y)
{
    array_push(route_points, { x: _x, y: _y });
}

function __customer_get_seat_facing(_tbl, _s)
{
    var _facing = "up";

    if (_tbl != noone && instance_exists(_tbl))
    {
        if (variable_instance_exists(_tbl, "seat_facing"))
        {
            if (is_array(_tbl.seat_facing))
            {
                if (_s >= 0 && _s < array_length(_tbl.seat_facing))
                {
                    _facing = _tbl.seat_facing[_s];
                }
            }
        }
    }

    return _facing;
}

// ----------------------------------------------------
// Build route to assigned table seat
// ----------------------------------------------------
function __customer_build_table_path()
{
    __customer_clear_path();

    if (target_table == noone || !instance_exists(target_table)) exit;

    var _tbl = target_table;
    var _s = target_seat;

    if (_s < 0 || _s >= _tbl.seat_count) exit;

    var _seat_x = _tbl.x + _tbl.seat_xoff[_s];
    var _seat_y = _tbl.y + _tbl.seat_yoff[_s];

    var _facing = __customer_get_seat_facing(_tbl, _s);

    var _tw = sprite_get_width(_tbl.sprite_index);
    var _th = sprite_get_height(_tbl.sprite_index);

    // ------------------------------------------------
    // Pick a side/aisle point.
    // Normally use the side closest to where the customer currently is.
    // If stuck, route_side_flip swaps side.
    // ------------------------------------------------
    var _side_x;

    var _normally_left = (x < _tbl.x);

    if (route_side_flip)
    {
        _normally_left = !_normally_left;
    }

    if (_normally_left)
    {
        _side_x = _tbl.x - _tw * 0.5 - 40;
    }
    else
    {
        _side_x = _tbl.x + _tw * 0.5 + 40;
    }

    // ------------------------------------------------
    // Approach from correct seating side.
    // Top seats approach from above table.
    // Bottom seats approach from below table.
    // ------------------------------------------------
    var _approach_x = _seat_x;
    var _approach_y = _seat_y;

    if (_facing == "down")
    {
        // Top-side seat: customer sits above table, facing down.
        _approach_y = _tbl.y - _th - 40;
    }
    else
    {
        // Bottom-side seat: customer sits below table, facing up.
        _approach_y = _tbl.y + 52;
    }

    // Route:
    // 1. move to side/aisle line
    // 2. move across to seat approach
    // 3. step into seat
    __customer_add_path_point(_side_x, _approach_y);
    __customer_add_path_point(_approach_x, _approach_y);
    __customer_add_path_point(_seat_x, _seat_y);
}

// ----------------------------------------------------
// Build route back to spawn point
// Uses orthogonal movement to avoid diagonal table scraping.
// ----------------------------------------------------
function __customer_build_exit_path()
{
    __customer_clear_path();

    // ------------------------------------------------
    // Tunable exit routing values
    // ------------------------------------------------
    var _clearance = 64;

    // Pick a broad horizontal lane near the bottom exit.
    // Adjust this number if needed.
    var _exit_lane_y = room_height - 120;

    var _exit_x = spawn_x;
    var _exit_y = spawn_y;

    // ------------------------------------------------
    // If leaving from a table, get clear of that table first.
    // ------------------------------------------------
    if (target_table != noone && instance_exists(target_table) && target_seat >= 0)
    {
        var _tbl = target_table;
        var _s = target_seat;

        if (_s >= 0 && _s < _tbl.seat_count)
        {
            var _seat_x = _tbl.x + _tbl.seat_xoff[_s];
            var _seat_y = _tbl.y + _tbl.seat_yoff[_s];

            var _facing = __customer_get_seat_facing(_tbl, _s);

            var _tw = sprite_get_width(_tbl.sprite_index);
            var _th = sprite_get_height(_tbl.sprite_index);

            // ----------------------------------------
            // 1. Step away from the table on the side
            //    the customer is sitting on.
            // ----------------------------------------
            var _away_x = _seat_x;
            var _away_y = _seat_y;

            if (_facing == "down")
            {
                // Top-side seat.
                // Move further above table first.
                _away_y = _tbl.y - _th - _clearance;
            }
            else
            {
                // Bottom-side seat.
                // Move below table first.
                _away_y = _tbl.y + _clearance;
            }

            // ----------------------------------------
            // 2. Move horizontally clear of the table.
            //    Pick the side closer to the exit/spawn.
            // ----------------------------------------
            var _side_x;

            if (_exit_x < _tbl.x)
            {
                _side_x = _tbl.x - _tw * 0.5 - _clearance;
            }
            else
            {
                _side_x = _tbl.x + _tw * 0.5 + _clearance;
            }

            // ----------------------------------------
            // 3. Use Manhattan/orthogonal exit movement.
            //    No diagonal from table to exit.
            // ----------------------------------------
            __customer_add_path_point(_away_x, _away_y);
            __customer_add_path_point(_side_x, _away_y);
            __customer_add_path_point(_side_x, _exit_lane_y);
            __customer_add_path_point(_exit_x, _exit_lane_y);
        }
    }

    // Final step into the actual spawn/exit point.
    __customer_add_path_point(_exit_x, _exit_y);
}

// ----------------------------------------------------
// Build route to queue slot
// Queue movement uses one shared line route:
//
// spawn
// -> slightly up through doorway
// -> left/right to queue column
// -> straight up the queue line
// -> stop at assigned queue slot
// ----------------------------------------------------
function __customer_build_queue_path()
{
    __customer_clear_path();

    // ------------------------------------------------
    // Target queue slot
    // ------------------------------------------------
    var _qx = queue_x;
    var _qy = queue_y;

    // ------------------------------------------------
    // Shared queue column
    // Everyone should move to the SAME x column.
    // ------------------------------------------------
    var _queue_column_x = _qx;

    if (target_queue != noone && instance_exists(target_queue))
    {
        _queue_column_x = target_queue.x;
    }

    // ------------------------------------------------
    // Door entry lane.
    // This should be only slightly above the spawn/door.
    // ------------------------------------------------
    var _door_entry_y = y - 56;

    _door_entry_y = clamp(
        _door_entry_y,
        96,
        room_height - 80
    );

    // ------------------------------------------------
    // Route:
    // 1. Move slightly up through doorway.
    // 2. Move horizontally to the queue column.
    // 3. Move vertically up the queue line.
    // 4. Final tiny correction to exact slot if needed.
    // ------------------------------------------------
    __customer_add_path_point(x, _door_entry_y);
    __customer_add_path_point(_queue_column_x, _door_entry_y);
    __customer_add_path_point(_queue_column_x, _qy);
    __customer_add_path_point(_qx, _qy);
}

// ----------------------------------------------------
// Build route out of queue before heading to a table
// Uses the same line discipline as entering the queue.
// ----------------------------------------------------
function __customer_build_leave_queue_path()
{
    __customer_clear_path();

    // ------------------------------------------------
    // Queue column.
    // Keep target_queue alive until this path finishes.
    // ------------------------------------------------
    var _queue_column_x = x;

    if (target_queue != noone && instance_exists(target_queue))
    {
        _queue_column_x = target_queue.x;
    }

    // ------------------------------------------------
    // Door/entry lane.
    // This should match the queue entry path:
    // just inside the bottom entrance, not deep in the room.
    // ------------------------------------------------
    var _door_entry_y = spawn_y - 56;

    _door_entry_y = clamp(
        _door_entry_y,
        96,
        room_height - 80
    );

    // ------------------------------------------------
    // Route:
    // 1. Move to the queue column if needed.
    // 2. Move straight down the queue column.
    // 3. Move horizontally back to the safe central/door lane.
    //
    // After this, the normal walking_to_table route takes over.
    // ------------------------------------------------
    __customer_add_path_point(_queue_column_x, y);
    __customer_add_path_point(_queue_column_x, _door_entry_y);
    __customer_add_path_point(spawn_x, _door_entry_y);
}

// ----------------------------------------------------
// Follow current waypoint route
// ----------------------------------------------------
function __customer_follow_path(_spd)
{
    if (array_length(route_points) <= 0)
    {
        return true;
    }

    if (route_index >= array_length(route_points))
    {
        return true;
    }

    var _pt = route_points[route_index];

    var _arrived = __customer_move_to(_pt.x, _pt.y, _spd);

    if (_arrived)
    {
        route_index += 1;

        if (route_index >= array_length(route_points))
        {
            return true;
        }
    }

    return false;
}

// ----------------------------------------------------
// Stuck detection for route-following states
// ----------------------------------------------------
function __customer_check_stuck()
{
    var _moved = point_distance(x, y, last_x, last_y);

    if (_moved < 0.05)
    {
        stuck_timer += 1;
    }
    else
    {
        stuck_timer = 0;
    }

    last_x = x;
    last_y = y;

    if (stuck_timer > room_speed)
    {
        stuck_timer = 0;

        // Flip route side and rebuild route next step.
        route_side_flip = !route_side_flip;
        __customer_clear_path();

        if (global.debug_mode)
        {
            show_debug_message("[Customer] Route retry / flipped side.");
        }
    }
}

// ----------------------------------------------------
// Walking to queue
// ----------------------------------------------------
if (state == "walking_to_queue")
{
    // Build queue route once.
    if (array_length(route_points) <= 0)
    {
        __customer_build_queue_path();
    }

    var _arrived_queue = __customer_follow_path(move_spd);

    __customer_check_stuck();

    if (_arrived_queue)
    {
        x = queue_x;
        y = queue_y;

        state = "queued";

        stuck_timer = 0;
        route_side_flip = false;
        __customer_clear_path();
    }

    exit;
}

// ----------------------------------------------------
// Queued
// ----------------------------------------------------
if (state == "queued")
{
    // Queue patience drains more slowly for now.
    patience -= 0.5;

    if (patience <= 0)
    {
        reaction_text = "TOO LONG!";
        reaction_timer = room_speed;

        // Remove self from queue.
        if (target_queue != noone && instance_exists(target_queue))
        {
            with (target_queue)
            {
                for (var i = 0; i < slot_count; i++)
                {
                    if (queue_customer[i] == other.id)
                    {
                        queue_customer[i] = noone;
                    }
                }
            }
        }

        global.customers_left_angry += 1;

        __customer_clear_path();
        state = "leaving";
    }

    exit;
}

// ----------------------------------------------------
// Walking out of queue before heading to table
// ----------------------------------------------------
if (state == "walking_from_queue")
{
    if (array_length(route_points) <= 0)
    {
        __customer_build_leave_queue_path();
    }

    var _left_queue = __customer_follow_path(move_spd);

    __customer_check_stuck();

    if (_left_queue)
    {
        stuck_timer = 0;
        route_side_flip = false;
        __customer_clear_path();

        // Now we are safely out of the queue line.
        target_queue = noone;
        queue_index = -1;

        // Now use the normal table-aware route.
        state = "walking_to_table";
    }

    exit;
}

// ----------------------------------------------------
// Walking to assigned table seat
// ----------------------------------------------------
if (state == "walking_to_table")
{
    // Build table-aware route once.
    if (array_length(route_points) <= 0)
    {
        __customer_build_table_path();
    }

    var _arrived_table = __customer_follow_path(move_spd);

    __customer_check_stuck();

    if (_arrived_table)
    {
        x = sit_x;
        y = sit_y;

        state = "seated";

        stuck_timer = 0;
        route_side_flip = false;
        __customer_clear_path();
    }

    exit;
}

// ----------------------------------------------------
// Seated: waiting for food
// ----------------------------------------------------
if (state == "seated")
{
    patience -= 1;

    if (patience <= 0)
    {
        reaction_text = "TOO SLOW!";
        reaction_timer = room_speed;

        // Free seat.
        if (target_table != noone && instance_exists(target_table))
        {
            with (target_table)
            {
                var _s = other.target_seat;

                if (_s >= 0 && _s < seat_count)
                {
                    seat_customer[_s] = noone;
                    seat_reserved[_s] = false;
                }
            }
        }

        global.customers_left_angry += 1;

        __customer_clear_path();
        state = "leaving";
    }

    exit;
}

// ----------------------------------------------------
// Served: evaluate food once
// ----------------------------------------------------
if (state == "served")
{
    var _correct = false;
    var _burnt_wrong = false;

    if (served_kind == order_kind)
    {
        if (!is_undefined(served_data))
        {
            if (served_data.recipe == order_recipe && served_data.cook_state == order_cook_state)
            {
                _correct = true;
            }
        }
    }

    if (!is_undefined(served_data))
    {
        if (served_data.recipe == order_recipe && served_data.cook_state == "burnt")
        {
            _burnt_wrong = true;
        }
    }

    if (_correct)
    {
        reaction_text = "GOOD!";
        satisfaction = 100;
        pay_amount = 8;
    }
    else if (_burnt_wrong)
    {
        reaction_text = "BURNT!";
        satisfaction = 35;
        pay_amount = 3;
        global.customers_failed += 1;
    }
    else
    {
        reaction_text = "WRONG!";
        satisfaction = 20;
        pay_amount = 2;
        global.customers_failed += 1;
    }

    global.gold += pay_amount;
    global.shift_revenue += pay_amount;
    global.customers_served += 1;

    reaction_timer = room_speed;
    eat_timer = room_speed * 2;

    state = "eating";
    exit;
}

// ----------------------------------------------------
// Eating
// ----------------------------------------------------
if (state == "eating")
{
    eat_timer -= 1;

    if (eat_timer <= 0)
    {
        // Convert served food into dirty plate.
        if (served_table != noone && instance_exists(served_table))
        {
            with (served_table)
            {
                var _s = other.served_seat;

                if (_s >= 0 && _s < seat_count)
                {
                    seat_has_food[_s] = false;
                    seat_food_sprite[_s] = -1;
                    seat_food_kind[_s] = "";
                    seat_food_name[_s] = "";
                    seat_food_data[_s] = undefined;

                    seat_has_dirty_plate[_s] = true;

                    seat_customer[_s] = noone;
                    seat_reserved[_s] = false;
                }
            }
        }

        __customer_clear_path();
        state = "leaving";
    }

    exit;
}

// ----------------------------------------------------
// Leaving: walk back to spawn point, then disappear
// ----------------------------------------------------
if (state == "leaving")
{
    // Build exit route once.
    if (array_length(route_points) <= 0)
    {
        __customer_build_exit_path();
    }

    var _arrived_exit = __customer_follow_path(move_spd);

    __customer_check_stuck();

    if (_arrived_exit)
    {
        if (!has_left_counted)
        {
            global.active_customers -= 1;
            has_left_counted = true;
        }

        instance_destroy();
    }

    exit;
}