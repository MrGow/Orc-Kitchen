/// oGame — Step
// Central low-level ticking.
// Actual kitchen logic should live in managers later.

global.frame += 1;

// ----------------------------------------------------
// Recipe menu toggle
// ----------------------------------------------------
var _gp = 0;

var _recipe_pressed = keyboard_check_pressed(ord("R"));

if (gamepad_is_connected(_gp))
{
    if (gamepad_button_check_pressed(_gp, gp_select))
    {
        _recipe_pressed = true;
    }
}

if (_recipe_pressed)
{
    global.recipe_menu_open = !global.recipe_menu_open;

    if (global.recipe_menu_open)
    {
        global.recipe_menu_was_open = true;
        global.paused = true;
        global.player_can_move = false;
        global.player_can_interact = false;
    }
    else
    {
        global.recipe_menu_was_open = false;
        global.paused = false;
        global.player_can_move = true;
        global.player_can_interact = true;
    }
}

// While recipe menu is open, freeze gameplay logic.
if (global.recipe_menu_open)
{
    global.paused = true;
    global.player_can_move = false;
    global.player_can_interact = false;
    exit;
}

// ----------------------------------------------------
// Fullscreen toggle
// ----------------------------------------------------
var _fullscreen_pressed = false;

if (keyboard_check_pressed(vk_f11))
{
    _fullscreen_pressed = true;
}

if (keyboard_check(vk_alt) && keyboard_check_pressed(vk_enter))
{
    _fullscreen_pressed = true;
}

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
// Pause toggle
// ----------------------------------------------------
var _pause_pressed = false;

if (keyboard_check_pressed(vk_escape)) _pause_pressed = true;
if (keyboard_check_pressed(ord("P"))) _pause_pressed = true;

if (gamepad_is_connected(0))
{
    if (gamepad_button_check_pressed(0, gp_start)) _pause_pressed = true;
}

if (_pause_pressed)
{
    global.paused = !global.paused;
}

if (global.paused)
{
    global.player_can_move = false;
    global.player_can_interact = false;
    exit;
}

global.player_can_move = true;
global.player_can_interact = true;

// ----------------------------------------------------
// Station label helper
// ----------------------------------------------------
global.show_station_labels = keyboard_check(vk_tab);

// ----------------------------------------------------
// DAY / SHIFT STATE MACHINE
// ----------------------------------------------------

// ----------------------------------------------------
// PRE-SHIFT COUNTDOWN
// ----------------------------------------------------
if (global.day_phase == "pre_shift")
{
    global.game_state = "kitchen";
    global.shift_state = "pre_shift";
    global.can_leave_mess_hall = false;

    global.pre_shift_timer -= 1;

    var _seconds_left = ceil(global.pre_shift_timer / room_speed);
    _seconds_left = max(1, _seconds_left);

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

// ----------------------------------------------------
// ACTIVE COOKING SHIFT
// ----------------------------------------------------
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

        global.shift_banner_text = "SHIFT ENDED!";
        global.shift_banner_timer = room_speed * 2;

        show_debug_message("[oGame] Shift closing.");
    }
}

// ----------------------------------------------------
// CLOSING: no more spawning, wait until customers are gone
// ----------------------------------------------------
else if (global.day_phase == "closing")
{
    global.game_state = "kitchen";
    global.shift_state = "closing";
    global.can_leave_mess_hall = false;

    if (global.active_customers <= 0)
    {
        global.active_customers = 0;

        global.day_phase = "shift_summary";
        global.shift_state = "shift_summary";

        global.summary_timer = 0;
        global.shift_report_ready = true;

        show_debug_message("[oGame] Shift summary ready.");
    }
}

// ----------------------------------------------------
// SHIFT SUMMARY SCREEN
// ----------------------------------------------------
else if (global.day_phase == "shift_summary")
{
    global.game_state = "kitchen";
    global.shift_state = "shift_summary";
    global.can_leave_mess_hall = false;

    global.summary_timer += 1;

    var _continue_pressed =
        keyboard_check_pressed(vk_space)
        || keyboard_check_pressed(vk_enter)
        || keyboard_check_pressed(ord("E"));

    if (
        global.summary_timer >= global.summary_min_time
        && _continue_pressed
    )
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

// ----------------------------------------------------
// CLEANUP / EMPTY EVENING MESS HALL
// ----------------------------------------------------
else if (global.day_phase == "cleanup")
{
    global.game_state = "kitchen";
    global.shift_state = "cleanup";
    global.can_leave_mess_hall = true;
}

// ----------------------------------------------------
// NON-KITCHEN PHASES
// ----------------------------------------------------
else if (global.day_phase == "camp_map")
{
    global.game_state = "camp_map";
    global.can_leave_mess_hall = false;
}
else if (global.day_phase == "market")
{
    global.game_state = "market";
    global.can_leave_mess_hall = false;
}
else if (global.day_phase == "home")
{
    global.game_state = "home";
    global.can_leave_mess_hall = false;
}

// ----------------------------------------------------
// Banner timer
// ----------------------------------------------------
if (global.shift_banner_timer > 0)
{
    global.shift_banner_timer -= 1;
}

// ----------------------------------------------------
// Filth clamp
// ----------------------------------------------------
global.filth = clamp(global.filth, 0, global.filth_max);

// ----------------------------------------------------
// Shift report calculation
// ----------------------------------------------------
global.shift_net_profit =
    global.shift_revenue
    + global.shift_tips
    - global.shift_ingredient_costs
    - global.shift_repair_costs
    - global.shift_wages;

// ----------------------------------------------------
// Debug hotkeys
// ----------------------------------------------------
if (global.ok_debug)
{
    // Restart pre-shift.
    if (keyboard_check_pressed(ord("1")))
    {
        global.day_phase = "pre_shift";
        global.shift_state = "pre_shift";

        global.pre_shift_timer = global.pre_shift_time_limit;
        global.shift_timer = global.shift_time_limit;

        global.can_leave_mess_hall = false;

        show_debug_message("[oGame] Debug: pre-shift restarted.");
    }

    // Force shift end / closing.
    if (keyboard_check_pressed(ord("2")))
    {
        global.day_phase = "closing";
        global.shift_state = "closing";

        global.shift_timer = 0;

        global.shift_banner_text = "SHIFT ENDED!";
        global.shift_banner_timer = room_speed * 2;

        show_debug_message("[oGame] Debug: shift forced to closing.");
    }

    // Add money.
    if (keyboard_check_pressed(ord("3")))
    {
        global.gold += 10;
        show_debug_message("[oGame] Debug: +10 gold.");
    }

    // Add filth.
    if (keyboard_check_pressed(ord("4")))
    {
        global.filth += 10;
        show_debug_message("[oGame] Debug: +10 filth.");
    }

    // Clean filth.
    if (keyboard_check_pressed(ord("5")))
    {
        global.filth -= 10;
        show_debug_message("[oGame] Debug: -10 filth.");
    }

    // Force cleanup.
    if (keyboard_check_pressed(ord("6")))
    {
        global.day_phase = "cleanup";
        global.shift_state = "cleanup";
        global.can_leave_mess_hall = true;

        show_debug_message("[oGame] Debug: cleanup phase.");
    }
}