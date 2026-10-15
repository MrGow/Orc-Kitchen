/// oGame — Step
// Central ticking; main menu never advances the campaign.

global.frame += 1;

// ----------------------------------------------------
// Fullscreen toggle — available in every room
// ----------------------------------------------------
var _fullscreen_pressed = keyboard_check_pressed(vk_f11)
    || (keyboard_check(vk_alt) && keyboard_check_pressed(vk_enter));

if (_fullscreen_pressed)
{
    global.is_fullscreen = !window_get_fullscreen();
    window_set_fullscreen(global.is_fullscreen);

    if (!global.is_fullscreen)
    {
        window_set_size(global.windowed_w, global.windowed_h);
        window_center();
    }

    display_set_gui_size(global.GUI_W, global.GUI_H);
    show_debug_message("[oGame] Fullscreen: " + string(global.is_fullscreen));
}

// ----------------------------------------------------
// Main menu — no campaign simulation or game hotkeys
// ----------------------------------------------------
if (room == MainMenuRoom)
{
    global.game_state = "main_menu";
    global.paused = false;
    global.recipe_menu_open = false;
    global.recipe_menu_was_open = false;
    global.show_station_labels = false;
    global.player_can_move = false;
    global.player_can_interact = false;
    exit;
}

// ----------------------------------------------------
// Recipe menu toggle
// ----------------------------------------------------
var _gp = 0;
var _recipe_pressed = keyboard_check_pressed(ord("R"));

if (gamepad_is_connected(_gp))
{
    if (gamepad_button_check_pressed(_gp, gp_select))
        _recipe_pressed = true;
}

if (_recipe_pressed)
{
    global.recipe_menu_open = !global.recipe_menu_open;
    global.recipe_menu_was_open = global.recipe_menu_open;
    global.paused = global.recipe_menu_open;
    global.player_can_move = !global.recipe_menu_open;
    global.player_can_interact = !global.recipe_menu_open;
}

if (global.recipe_menu_open)
{
    global.paused = true;
    global.player_can_move = false;
    global.player_can_interact = false;
    exit;
}

// ----------------------------------------------------
// Pause toggle
// ----------------------------------------------------
var _pause_pressed = keyboard_check_pressed(vk_escape)
    || keyboard_check_pressed(ord("P"));

if (gamepad_is_connected(0))
{
    if (gamepad_button_check_pressed(0, gp_start))
        _pause_pressed = true;
}

if (_pause_pressed)
    global.paused = !global.paused;

if (global.paused)
{
    global.player_can_move = false;
    global.player_can_interact = false;
    exit;
}

global.player_can_move = true;
global.player_can_interact = true;
global.show_station_labels = keyboard_check(vk_tab);

// ----------------------------------------------------
// Day / shift state machine — only active in MessHall
// ----------------------------------------------------
if (room == MessHall)
{
    if (global.day_phase == "pre_shift")
    {
        global.game_state = "kitchen";
        global.shift_state = "pre_shift";
        global.can_leave_mess_hall = false;
        global.pre_shift_timer -= 1;

        var _seconds_left = max(1, ceil(global.pre_shift_timer / room_speed));
        global.shift_banner_text = "SHIFT BEGINS " + string(_seconds_left);
        global.shift_banner_timer = 2;

        if (global.pre_shift_timer <= 0)
        {
            global.pre_shift_timer = 0;
            global.day_phase = "serving";
            global.shift_state = "serving";
            global.shift_timer = global.shift_time_limit;
            global.shift_banner_text = "WAR PARTY INCOMING!";
            global.shift_banner_timer = room_speed * 2;
            show_debug_message("[oGame] Shift started.");
        }
    }
    else if (global.day_phase == "serving")
    {
        global.game_state = "kitchen";
        global.shift_state = "serving";
        global.can_leave_mess_hall = false;
        global.shift_timer -= 1;

        if (global.shift_timer <= 0)
        {
            global.shift_timer = 0;
            global.day_phase = "closing";
            global.shift_state = "closing";
            global.shift_banner_text = "LAST CALL!";
            global.shift_banner_timer = room_speed * 3;
            global.closing_timer = room_speed * 90;
            show_debug_message("[oGame] Last Call started.");
        }
    }
    else if (global.day_phase == "closing")
    {
        global.game_state = "kitchen";
        global.shift_state = "closing";
        global.can_leave_mess_hall = false;

        // No new arrivals. Existing customers can finish naturally.
        global.closing_timer = max(0, global.closing_timer - 1);

        if (instance_number(oCustomer) == 0 || global.closing_timer <= 0)
        {
            global.day_phase = "shift_summary";
            global.shift_state = "shift_summary";
            global.summary_timer = 0;
            global.shift_report_ready = true;
            global.shift_banner_text = "";
            global.shift_banner_timer = 0;

            // Remove any stragglers BEFORE the summary is displayed.
            // Destroy events (if added later) should not count them as angry.
            with (oCustomer)
            {
                if (target_table != noone && instance_exists(target_table))
                {
                    var _tbl = target_table;
                    var _seat = target_seat;
                    if (_seat >= 0 && _seat < _tbl.seat_count)
                    {
                        if (_tbl.seat_customer[_seat] == id)
                        {
                            _tbl.seat_customer[_seat] = noone;
                            _tbl.seat_reserved[_seat] = false;
                        }
                    }
                }
                if (target_queue != noone && instance_exists(target_queue))
                {
                    var _queue = target_queue;
                    for (var _q = 0; _q < _queue.slot_count; _q++)
                    {
                        if (_queue.queue_customer[_q] == id)
                            _queue.queue_customer[_q] = noone;
                    }
                }
                instance_destroy();
            }
            global.active_customers = 0;
            global.customer_queue_length = 0;
            show_debug_message("[oGame] Shift summary ready; customers cleared.");
        }
    }
    else if (global.day_phase == "shift_summary")
    {
        global.game_state = "kitchen";
        global.shift_state = "shift_summary";
        global.can_leave_mess_hall = false;
        global.summary_timer += 1;

        var _continue_pressed = keyboard_check_pressed(vk_space)
            || keyboard_check_pressed(vk_enter)
            || keyboard_check_pressed(ord("E"));

        if (global.summary_timer >= global.summary_min_time && _continue_pressed)
        {
            global.day_phase = "cleanup";
            global.shift_state = "cleanup";
            global.can_leave_mess_hall = true;
            global.shift_report_ready = false;
            global.shift_banner_text = "CLEANUP TIME";
            global.shift_banner_timer = room_speed * 2;
            show_debug_message("[oGame] Cleanup phase started.");
        }
    }
    else if (global.day_phase == "cleanup")
    {
        global.game_state = "kitchen";
        global.shift_state = "cleanup";
        global.can_leave_mess_hall = true;
    }
}
else
{
    // Non-kitchen phases never advance the shift.
    if (global.day_phase == "camp_map")
        global.game_state = "camp_map";
    else if (global.day_phase == "market")
        global.game_state = "market";
    else if (global.day_phase == "home")
        global.game_state = "home";

    global.can_leave_mess_hall = false;
}

// ----------------------------------------------------
// Banner timer
// ----------------------------------------------------
if (global.shift_banner_timer > 0)
    global.shift_banner_timer -= 1;

// ----------------------------------------------------
// Filth clamp and shift profit
// ----------------------------------------------------
global.filth = clamp(global.filth, 0, global.filth_max);

global.shift_net_profit = global.shift_revenue
    + global.shift_tips
    - global.shift_ingredient_costs
    - global.shift_repair_costs
    - global.shift_wages;

// ----------------------------------------------------
// Debug hotkeys (only in MessHall)
// ----------------------------------------------------
if (global.ok_debug && room == MessHall)
{
    if (keyboard_check_pressed(ord("1")))
    {
        global.day_phase = "pre_shift";
        global.shift_state = "pre_shift";
        global.pre_shift_timer = global.pre_shift_time_limit;
        global.shift_timer = global.shift_time_limit;
        global.closing_timer = 0;
        global.can_leave_mess_hall = false;
        show_debug_message("[oGame] Debug: pre-shift restarted.");
    }

    if (keyboard_check_pressed(ord("2")))
    {
        global.day_phase = "closing";
        global.shift_state = "closing";
        global.shift_timer = 0;
        global.shift_banner_text = "LAST CALL!";
        global.shift_banner_timer = room_speed * 3;
        global.closing_timer = room_speed * 90;
        show_debug_message("[oGame] Debug: shift forced to closing.");
    }

    if (keyboard_check_pressed(ord("3")))
    {
        global.gold += 10;
        show_debug_message("[oGame] Debug: +10 gold.");
    }

    if (keyboard_check_pressed(ord("4")))
    {
        global.filth += 10;
        show_debug_message("[oGame] Debug: +10 filth.");
    }

    if (keyboard_check_pressed(ord("5")))
    {
        global.filth -= 10;
        show_debug_message("[oGame] Debug: -10 filth.");
    }

    if (keyboard_check_pressed(ord("6")))
    {
        global.day_phase = "closing";
        global.shift_state = "closing";
        global.closing_timer = 0;
        global.can_leave_mess_hall = false;
        show_debug_message("[oGame] Debug: finish Last Call and show summary.");
    }
}
