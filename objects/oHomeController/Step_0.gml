/// oHomeController — Step Event

var _up =
    keyboard_check_pressed(vk_up)
    || keyboard_check_pressed(ord("W"));

var _down =
    keyboard_check_pressed(vk_down)
    || keyboard_check_pressed(ord("S"));

var _confirm =
    keyboard_check_pressed(vk_space)
    || keyboard_check_pressed(vk_enter)
    || keyboard_check_pressed(ord("E"));

if (_up)
{
    selected -= 1;
}

if (_down)
{
    selected += 1;
}

selected = clamp(selected, 0, array_length(menu_items) - 1);

if (_confirm)
{
    var _choice = menu_items[selected];

    // ----------------------------------------------------
    // BACK TO CAMP MAP
    // ----------------------------------------------------
    if (_choice == "Back to Camp Map")
    {
        global.day_phase = "camp_map";
        global.game_state = "camp_map";
        global.can_leave_mess_hall = false;

        room_goto(WarCampMap);
    }

    // ----------------------------------------------------
    // SLEEP / START NEXT DAY
    // ----------------------------------------------------
    else if (_choice == "Sleep")
    {
        // Advance day.
        global.day += 1;

        // Reset shift stats.
        global.shift_revenue = 0;
        global.shift_tips = 0;
        global.shift_ingredient_costs = 0;
        global.shift_repair_costs = 0;
        global.shift_wages = 0;
        global.shift_net_profit = 0;

        global.customers_spawned = 0;
        global.customers_served = 0;
        global.customers_failed = 0;
        global.customers_left_angry = 0;
        global.active_customers = 0;

        global.orders_created = 0;
        global.orders_completed = 0;
        global.orders_failed = 0;

        global.customer_queue_length = 0;

        global.food_wasted = 0;
        global.waste_cost = 0;

        global.mess_created_this_shift = 0;
        global.mess_cleaned_this_shift = 0;

        global.repairs_done_this_shift = 0;

        // Reset shift state.
        global.game_state = "kitchen";
        global.day_phase = "pre_shift";
        global.shift_state = "pre_shift";

        // Reset timers.
        global.pre_shift_timer = global.pre_shift_time_limit;
        global.shift_timer = global.shift_time_limit;

        global.summary_timer = 0;
        global.shift_report_ready = false;

        global.shift_banner_text = "";
        global.shift_banner_timer = 0;

        // Player cannot leave during the morning countdown / shift.
        global.can_leave_mess_hall = false;

        show_debug_message("[Home] Slept. Starting day " + string(global.day));

        room_goto(MessHall);
    }
}