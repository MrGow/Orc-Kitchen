/// oSleepTransition — Step
// Keep input locked until the new day is visible.

global.sleep_transition_active = true;
global.player_can_move = false;
global.player_can_interact = false;

switch (transition_state)
{
    case "fade_out":
    {
        transition_frame += 1;
        transition_alpha = clamp(transition_frame / fade_out_frames, 0, 1);

        if (transition_frame >= fade_out_frames)
        {
            transition_alpha = 1;
            transition_frame = 0;
            transition_state = "sleep_hold";
        }
        break;
    }

    case "sleep_hold":
    {
        transition_alpha = 1;
        transition_frame += 1;

        if (transition_frame >= sleep_hold_frames)
        {
            // Reset exactly once, while fully covered by black.
            if (!day_advanced)
            {
                day_advanced = true;
                global.day += 1;

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

                global.game_state = "kitchen";
                global.day_phase = "pre_shift";
                global.shift_state = "pre_shift";
                global.pre_shift_timer = global.pre_shift_time_limit;
                global.shift_timer = global.shift_time_limit;
                global.shift_elapsed = 0;
                global.closing_timer = 0;
                global.summary_timer = 0;
                global.shift_report_ready = false;
                global.shift_banner_text = "";
                global.shift_banner_timer = 0;
                global.can_leave_mess_hall = false;
                global.evening_activity_used = false;

                // oGame Room Start will roll the new day profile/schedule.
                // oGame Step remains frozen until fade-in finishes.
                if (global.ok_debug)
                    show_debug_message("[SleepTransition] Starting day " + string(global.day));
            }

            transition_state = "wait_room";
            transition_frame = 0;
            room_goto(MessHall);
        }
        break;
    }

    case "wait_room":
    {
        // room_goto completes after the frame; retain full blackout
        // until the new room is actually active.
        transition_alpha = 1;
        if (room == MessHall)
        {
            transition_state = "fade_in";
            transition_frame = 0;
        }
        break;
    }

    case "fade_in":
    {
        transition_frame += 1;
        transition_alpha = 1 - clamp(transition_frame / fade_in_frames, 0, 1);

        if (transition_frame >= fade_in_frames)
        {
            transition_alpha = 0;
            transition_state = "finished";
        }
        break;
    }

    case "finished":
    {
        // From the following frame, oGame may tick the 5-second countdown.
        global.sleep_transition_active = false;
        global.player_can_move = true;
        global.player_can_interact = true;
        instance_destroy();
        break;
    }
}
