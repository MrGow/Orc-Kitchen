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

    // X movement
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
                if (__customer_can_stand_at(x + _sx, y)) x += _sx;
                else break;
            }
        }
    }

    // Y movement
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
                if (__customer_can_stand_at(x, y + _sy)) y += _sy;
                else break;
            }
        }
    }

    return false;
}

// ----------------------------------------------------
// Walking to queue
// ----------------------------------------------------
if (state == "walking_to_queue")
{
    var _arrived_queue = __customer_move_to(queue_x, queue_y, move_spd);

    if (_arrived_queue)
    {
        state = "queued";
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

        state = "leaving";
    }

    exit;
}

// ----------------------------------------------------
// Walking to assigned table seat
// ----------------------------------------------------
if (state == "walking_to_table")
{
    var _arrived_table = __customer_move_to(sit_x, sit_y, move_spd);

    if (_arrived_table)
    {
        state = "seated";
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

        state = "leaving";
    }

    exit;
}

// ----------------------------------------------------
// Leaving: walk back to spawn point, then disappear
// ----------------------------------------------------
if (state == "leaving")
{
    var _arrived_exit = __customer_move_to(spawn_x, spawn_y, move_spd);

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