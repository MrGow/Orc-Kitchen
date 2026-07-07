/// oCustomer — Step Event

if (global.paused) exit;

depth = -y;

if (reaction_timer > 0)
{
    reaction_timer -= 1;
}

// ----------------------------------------------------
// Walking to assigned seat
// ----------------------------------------------------
if (state == "walking_to_table")
{
    var _d = point_distance(x, y, sit_x, sit_y);

    if (_d > 2)
    {
        var _dir = point_direction(x, y, sit_x, sit_y);
        x += lengthdir_x(move_spd, _dir);
        y += lengthdir_y(move_spd, _dir);
    }
    else
    {
        x = sit_x;
        y = sit_y;
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
        reaction_timer = room_speed * 1;

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
        global.active_customers -= 1;

        state = "leaving";
        leave_timer = room_speed * 1;
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

    // Proper correct check:
    // Customer wants meal_skewered_rat with cook_state = cooked.
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

    // Burnt rat is the same recipe but wrong cook state.
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
    }
    else
    {
        reaction_text = "WRONG!";
        satisfaction = 20;
        pay_amount = 2;
    }

    global.gold += pay_amount;
    global.shift_revenue += pay_amount;
    global.customers_served += 1;

    reaction_timer = room_speed * 1;
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

        global.active_customers -= 1;

        state = "leaving";
        leave_timer = room_speed * 1;
    }

    exit;
}

// ----------------------------------------------------
// Leaving
// ----------------------------------------------------
if (state == "leaving")
{
    leave_timer -= 1;

    // For now just disappear.
    if (leave_timer <= 0)
    {
        instance_destroy();
    }

    exit;
}