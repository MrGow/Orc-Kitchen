/// oGame — Room Start
// Refresh room references and detect current location.

game_set_speed(60, gamespeed_fps);
gpu_set_texfilter(false);
display_set_gui_size(global.GUI_W, global.GUI_H);

// ----------------------------------------------------
// Layer references
// ----------------------------------------------------
global.layer_floor = layer_get_id("Floor");
global.layer_walls = layer_get_id("Walls");
global.layer_instances = layer_get_id("Instances");
global.layer_actors = layer_get_id("Actors");
global.layer_ui = layer_get_id("UI");

if (global.layer_instances == -1)
    global.layer_instances = layer_create(0, "Instances");

if (global.layer_actors == -1)
    global.layer_actors = layer_create(-100, "Actors");

if (global.layer_ui == -1)
    global.layer_ui = layer_create(-10000, "UI");

// ----------------------------------------------------
// Tilemap references
// ----------------------------------------------------
global.tm_floor = undefined;
global.tm_walls = undefined;

if (global.layer_floor != -1)
{
    var _tm_floor = layer_tilemap_get_id(global.layer_floor);
    if (_tm_floor != -1) global.tm_floor = _tm_floor;
}

if (global.layer_walls != -1)
{
    var _tm_walls = layer_tilemap_get_id(global.layer_walls);
    if (_tm_walls != -1) global.tm_walls = _tm_walls;
}

// ----------------------------------------------------
// Last Call timer (initialized once for older saves/controllers)
// ----------------------------------------------------
if (!variable_global_exists("closing_timer"))
    global.closing_timer = 0;

// ----------------------------------------------------
// Room state detection
// ----------------------------------------------------
global.current_room = room;
global.current_room_name = room_get_name(room);

if (room == MainMenuRoom)
{
    global.game_state = "main_menu";
    global.paused = false;
    global.recipe_menu_open = false;
    global.recipe_menu_was_open = false;
    global.shift_banner_text = "";
    global.shift_banner_timer = 0;
    global.can_leave_mess_hall = false;
}
else if (room == MessHall)
{
    global.game_state = "kitchen";

    // Supports existing New Game handlers that only call room_goto.
    // For a real New Game reset, use the separate new-game initialization.
    if (!global.campaign_started)
    {
        global.campaign_started = true;
        global.day_phase = "pre_shift";
        global.shift_state = "pre_shift";
        global.pre_shift_timer = global.pre_shift_time_limit;
        global.shift_timer = global.shift_time_limit;
        global.shift_banner_text = "";
        global.shift_banner_timer = 0;
    }

    if (global.day_phase == "cleanup")
    {
        global.shift_state = "cleanup";
        global.can_leave_mess_hall = true;
    }
    else if (global.day_phase == "pre_shift")
    {
        global.shift_state = "pre_shift";
        global.can_leave_mess_hall = false;

        if (global.pre_shift_timer <= 0)
            global.pre_shift_timer = global.pre_shift_time_limit;

        if (global.shift_timer <= 0)
            global.shift_timer = global.shift_time_limit;
    }
    else
    {
        global.can_leave_mess_hall = false;
    }
}
else if (room == WarCampMap)
{
    global.game_state = "camp_map";
    global.day_phase = "camp_map";
    global.can_leave_mess_hall = false;
}
else if (room == Market)
{
    global.game_state = "market";
    global.day_phase = "market";
    global.can_leave_mess_hall = false;
}
else if (room == Home)
{
    global.game_state = "home";
    global.day_phase = "home";
    global.can_leave_mess_hall = false;
}

// ----------------------------------------------------
// Reset per-room helpers
// ----------------------------------------------------
global.show_station_labels = false;
global.player_can_move = (room != MainMenuRoom);
global.player_can_interact = (room != MainMenuRoom);

show_debug_message("[oGame] Room Start: " + global.current_room_name);
