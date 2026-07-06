/// oGame — Step
// Central low-level ticking.
// Actual kitchen logic should live in managers later.

global.frame += 1;

// ----------------------------------------------------
// Fullscreen toggle
// ----------------------------------------------------
// F11 = toggle fullscreen.
// Alt + Enter also works as backup.
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
        // Restore nice development window size.
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

// While paused, freeze high-level timers.
// Individual objects should also early-exit their Step events with:
// if (global.paused) exit;
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
// Hold TAB to show station names later.
global.show_station_labels = keyboard_check(vk_tab);

// ----------------------------------------------------
// Shift timer
// ----------------------------------------------------
if (global.game_state == "kitchen")
{
    if (global.shift_state == "serving")
    {
        global.shift_timer += 1;

        if (global.shift_timer >= global.shift_time_limit)
        {
            global.shift_state = "cleanup";
            show_debug_message("[oGame] Shift moved to cleanup.");
        }
    }
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
if (global.debug_mode)
{
    // Start active serving shift.
    if (keyboard_check_pressed(ord("1")))
    {
        global.shift_state = "serving";
        global.shift_timer = 0;
        show_debug_message("[oGame] Debug: shift started.");
    }

    // End shift.
    if (keyboard_check_pressed(ord("2")))
    {
        global.shift_state = "ended";
        global.shift_report_ready = true;
        show_debug_message("[oGame] Debug: shift ended.");
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
}