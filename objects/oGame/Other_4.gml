/// oGame — Room Start
// Runs whenever a new room starts.
// Good place to reacquire room layers and apply safe defaults.

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

// Create useful layers if missing.
// This keeps new test rooms from breaking immediately.
if (global.layer_instances == -1)
{
    global.layer_instances = layer_create(0, "Instances");
}

if (global.layer_actors == -1)
{
    global.layer_actors = layer_create(-100, "Actors");
}

if (global.layer_ui == -1)
{
    global.layer_ui = layer_create(-10000, "UI");
}

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
// Room type detection
// ----------------------------------------------------
global.current_room = room;
global.current_room_name = room_get_name(room);

// Exact room names currently used:
// MessHall, WarCampMap, Market, Home
if (global.current_room_name == "MessHall")
{
    global.game_state = "kitchen";

    if (global.day_phase == "cleanup")
    {
        global.shift_state = "cleanup";
        global.can_leave_mess_hall = true;
    }

    if (global.day_phase == "pre_shift")
    {
        global.shift_state = "pre_shift";
        global.can_leave_mess_hall = false;

        if (global.pre_shift_timer <= 0)
        {
            global.pre_shift_timer = global.pre_shift_time_limit;
        }

        if (global.shift_timer <= 0)
        {
            global.shift_timer = global.shift_time_limit;
        }
    }
}
else if (global.current_room_name == "WarCampMap")
{
    global.game_state = "camp_map";
    global.day_phase = "camp_map";
    global.can_leave_mess_hall = false;
}
else if (global.current_room_name == "Market")
{
    global.game_state = "market";
    global.day_phase = "market";
    global.can_leave_mess_hall = false;
}
else if (global.current_room_name == "Home")
{
    global.game_state = "home";
    global.day_phase = "home";
    global.can_leave_mess_hall = false;
}

// ----------------------------------------------------
// Reset per-room helpers
// ----------------------------------------------------
global.show_station_labels = false;

global.player_can_move = true;
global.player_can_interact = true;

show_debug_message("[oGame] Room Start: " + global.current_room_name);