/// oCustomer — Step (FULL REPLACEMENT)
/// Fixed-footprint navigation for final Mess Hall layout.
/// Food, payment, patience and exit states preserved.

if (global.paused) exit;
depth = -y;
if (reaction_timer > 0) reaction_timer -= 1;

// ====================================================
// COLLISION: use fixed customer mask against solid furniture
// ====================================================
function __customer_can_stand_at(_xx, _yy)
{
    if (_xx < feet_half_w || _yy < feet_half_h
        || _xx >= room_width - feet_half_w
        || _yy >= room_height - feet_half_h) return false;

    var _old_x = x;
    var _old_y = y;
    x = _xx;
    y = _yy;

    // Includes children, such as oSolidBlock.
    var _blocked = place_meeting(x, y, oSolidStation);

    x = _old_x;
    y = _old_y;
    return !_blocked;
}

function __customer_clear_path()
{
    route_points = [];
    route_index = 0;
}

// ====================================================
// FIND WALKABLE PATH: 12px grid, 4-way (no corner cutting)
// Searches the actual room and all active furniture collisions.
// The seat itself may overlap a chair collision rectangle, so
// choose a reachable point NEAR the seat, then seat the customer.
// ====================================================
function __customer_route_to(_tx, _ty, _seat_goal, _seat_facing)
{
    __customer_clear_path();

    var _cell = 12;
    var _cols = ceil(room_width / _cell) + 1;
    var _rows = ceil(room_height / _cell) + 1;
    var _total = _cols * _rows;

    // Grid points are anchored to this customer's precise position.
    var _sx = floor(x / _cell);
    var _sy = floor(y / _cell);
    var _origin_x = x - _sx * _cell;
    var _origin_y = y - _sy * _cell;

    var _start = _sy * _cols + _sx;
    var _seen = array_create(_total, false);
    var _parent = array_create(_total, -1);
    var _queue = array_create(_total, 0);
    var _head = 0;
    var _tail = 1;
    _queue[0] = _start;
    _seen[_start] = true;

    var _best = -1;
    var _best_score = 1000000000;
	var _best_distance = 1000000000;

    while (_head < _tail)
    {
        var _node = _queue[_head];
        _head++;

        var _cx = _node mod _cols;
        var _cy = _node div _cols;
        var _wx = _origin_x + _cx * _cell;
        var _wy = _origin_y + _cy * _cell;
        var _dist = point_distance(_wx, _wy, _tx, _ty);

        var _candidate = false;
        var _score = _dist;

        if (_seat_goal)
        {
            // Do not select distant points and teleport to a chair.
            if (_dist <= 30)
            {
                _candidate = true;
                // Prefer the intended approach side of the table.
                if (_seat_facing == "down" && _wy > _ty + 5) _score += 25;
                if (_seat_facing == "up" && _wy < _ty - 5) _score += 25;
            }
        }
        else
        {
            // Ordinary queue and exit positions need a precise arrival.
            if (_dist <= 10) _candidate = true;
        }

        if (_candidate && _score < _best_score)
        {
            _best = _node;
            _best_score = _score;
            _best_distance = _dist;
            if (!_seat_goal && _dist < 0.1) break;
        }

        for (var _dir = 0; _dir < 4; _dir++)
        {
            var _nx = _cx;
            var _ny = _cy;
            if (_dir == 0) _nx++;
            if (_dir == 1) _nx--;
            if (_dir == 2) _ny++;
            if (_dir == 3) _ny--;

            if (_nx < 0 || _ny < 0 || _nx >= _cols || _ny >= _rows) continue;
            var _next = _ny * _cols + _nx;
            if (_seen[_next]) continue;

            var _px = _origin_x + _nx * _cell;
            var _py = _origin_y + _ny * _cell;
            if (!__customer_can_stand_at(_px, _py)) continue;

            // Check midpoint too, to prevent cutting through thin walls.
            if (!__customer_can_stand_at((_wx + _px) * 0.5, (_wy + _py) * 0.5)) continue;

            _seen[_next] = true;
            _parent[_next] = _node;
            _queue[_tail] = _next;
            _tail++;
        }
    }

    if (_best == -1)
    {
        if (global.ok_debug) show_debug_message("[Customer] No reachable path to (" + string(_tx) + "," + string(_ty) + "). Check table/queue positions and aisle widths.");
        return false;
    }

    var _reverse = [];
    var _cur = _best;
    while (_cur != _start && _cur != -1)
    {
        var _ix = _cur mod _cols;
        var _iy = _cur div _cols;
        array_push(_reverse, {x:_origin_x + _ix * _cell, y:_origin_y + _iy * _cell});
        _cur = _parent[_cur];
    }
    if (_cur == -1) return false;

    for (var _i = array_length(_reverse) - 1; _i >= 0; _i--)
    {
        array_push(route_points, _reverse[_i]);
    }

    var _bx = _origin_x + (_best mod _cols) * _cell;
    var _by = _origin_y + (_best div _cols) * _cell;

    // Store safe standing spot for customers leaving a seat later.
    if (_seat_goal)
    {
        seat_approach_x = _bx;
        seat_approach_y = _by;
    }
    else if (__customer_can_stand_at(_tx, _ty))
    {
        // Finish exactly on the target when free.
        array_push(route_points, {x:_tx, y:_ty});
    }

    route_index = 0;
    return true;
}

function __customer_get_seat_facing(_tbl, _s)
{
    if (instance_exists(_tbl)
        && variable_instance_exists(_tbl, "seat_facing")
        && is_array(_tbl.seat_facing)
        && _s >= 0 && _s < array_length(_tbl.seat_facing))
    {
        return _tbl.seat_facing[_s];
    }
    return "up";
}

function __customer_build_queue_path()
{
    // Direct, obstacle-aware routing: new queue is above entrance.
    return __customer_route_to(queue_x, queue_y, false, "");
}

function __customer_build_leave_queue_path()
{
    // Compatibility for older queue state; avoid walking back to door.
    return __customer_build_table_path();
}

function __customer_build_table_path()
{
    if (!instance_exists(target_table) || target_seat < 0)
    {
        __customer_clear_path();
        return false;
    }
    var _tbl = target_table;
    if (target_seat >= _tbl.seat_count) return false;
    var _facing = __customer_get_seat_facing(_tbl, target_seat);
    return __customer_route_to(sit_x, sit_y, true, _facing);
}

function __customer_build_exit_path()
{
    // If the visual seat overlaps a chair hitbox, return to the
    // walkable spot reached just before sitting, then path out.
    if (state == "leaving" && variable_instance_exists(id,"seat_approach_x"))
    {
        if (!__customer_can_stand_at(x, y)
            && __customer_can_stand_at(seat_approach_x, seat_approach_y))
        {
            x = seat_approach_x;
            y = seat_approach_y;
        }
    }
    return __customer_route_to(spawn_x, spawn_y, false, "");
}

// ====================================================
// MOVE TO NEXT PATH NODE. Subpixel movement, no rounding.
// ====================================================
function __customer_move_to(_tx, _ty, _spd)
{
    var _dx = _tx - x;
    var _dy = _ty - y;
    var _d = point_distance(x, y, _tx, _ty);
    if (_d <= 0.5) return true;

    var _step = min(_spd, _d);
    var _nx = _dx / _d * _step;
    var _ny = _dy / _d * _step;

    if (__customer_can_stand_at(x + _nx, y + _ny))
    {
        x += _nx;
        y += _ny;
    }
    else
    {
        if (__customer_can_stand_at(x + _nx, y)) x += _nx;
        if (__customer_can_stand_at(x, y + _ny)) y += _ny;
    }
    return point_distance(x, y, _tx, _ty) <= 0.6;
}

function __customer_follow_path(_spd)
{
    if (array_length(route_points) == 0) return false;
    if (route_index >= array_length(route_points)) return true;
    var _pt = route_points[route_index];
    if (__customer_move_to(_pt.x, _pt.y, _spd))
    {
        route_index++;
    }
    return route_index >= array_length(route_points);
}

function __customer_check_stuck()
{
    var _moved = point_distance(x, y, last_x, last_y);
    if (_moved < 0.05) stuck_timer++;
    else stuck_timer = 0;
    last_x = x;
    last_y = y;

    if (stuck_timer > room_speed)
    {
        stuck_timer = 0;
        __customer_clear_path();
        // Next Step will recalculate with the current furniture layout.
    }
}

// ====================================================
// ORIGINAL STATE MACHINE — FOOD, MONEY AND TIMERS PRESERVED
// ====================================================
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
        // Path has reached the queue; don't snap through furniture.
        if (__customer_can_stand_at(queue_x, queue_y))
        {
            x = queue_x;
            y = queue_y;
        }

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
        // Use the value for whichever dish was ordered.
        // Current values: Rat = 8 gold; Bat Wings = 10 gold.
        pay_amount = 8;
        if (order_recipe == "bat_wings") pay_amount = 10;
    }
    else if (_burnt_wrong)
    {
        reaction_text = "BURNT!";
        satisfaction = 35;
        // Preserve the existing burnt penalty for both recipes.
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