/// oGame — Create
// Persistent global controller for Orc Kitchen.
// Put one oGame in the first room only.

persistent = true;

// Prevent duplicate oGame instances after room changes.
if (instance_number(oGame) > 1)
{
    instance_destroy();
    exit;
}

// ----------------------------------------------------
// Base resolution / presentation
// ----------------------------------------------------
global.GAME_W = 640;
global.GAME_H = 360;

// Orc Kitchen is 64x64 base scale, so this is useful later.
global.TILE_SIZE = 64;

// GUI virtual size.
// 640x360 matches the current game camera.
global.GUI_W = 640;
global.GUI_H = 360;

display_set_gui_size(global.GUI_W, global.GUI_H);

// Useful for UI/world conversion later.
global._appsurf_scale = 1;
global._appsurf_xoff  = 0;
global._appsurf_yoff  = 0;

// ----------------------------------------------------
// Window / fullscreen
// ----------------------------------------------------
global.windowed_w = 1280;
global.windowed_h = 720;

global.is_fullscreen = false;

// Start windowed for development.
window_set_fullscreen(false);
window_set_size(global.windowed_w, global.windowed_h);
window_center();

// ----------------------------------------------------
// Runtime state
// ----------------------------------------------------
global.frame = 0;

global.paused = false;
global.debug_mode = true;

// Main high-level state.
// "boot", "kitchen", "shift_end", "home", "shop", "sleep"
global.game_state = "kitchen";

// Shift state.
// "prep", "serving", "cleanup", "ended"
global.shift_state = "prep";

global.day = 1;
global.shift_timer = 0;
global.shift_time_limit = room_speed * 180; // 3 minutes at 60 FPS for testing

// ----------------------------------------------------
// Economy
// ----------------------------------------------------
global.gold = 0;

global.shift_revenue = 0;
global.shift_tips = 0;
global.shift_ingredient_costs = 0;
global.shift_repair_costs = 0;
global.shift_wages = 0;
global.shift_net_profit = 0;

// ----------------------------------------------------
// Waste stats
// ----------------------------------------------------
// Increased by oStationGobbleToad when food is discarded.
global.food_wasted = 0;
global.waste_cost = 0;

// ----------------------------------------------------
// Customer / order tracking
// ----------------------------------------------------
global.customers_spawned = 0;
global.customers_served = 0;
global.customers_failed = 0;
global.customers_left_angry = 0;

global.active_customers = 0;
global.max_customers = 30;

global.orders_created = 0;
global.orders_completed = 0;
global.orders_failed = 0;

// Customer queue.
// If no seats are available, customers wait in line.
// If they wait too long, satisfaction/patience will drain.
global.customer_queue_length = 0;
global.customer_queue_max = 6;

// ----------------------------------------------------
// Satisfaction / patience defaults
// ----------------------------------------------------
global.customer_patience_max = room_speed * 45; // 45 seconds
global.customer_queue_patience_max = room_speed * 30;

global.satisfaction_perfect = 100;
global.satisfaction_good = 75;
global.satisfaction_ok = 50;
global.satisfaction_bad = 25;
global.satisfaction_angry = 0;

// ----------------------------------------------------
// Plate / container system
// ----------------------------------------------------
// Clean container stock.
global.containers_clean = {
    normal_plate : 6,
    big_plate    : 0,
    boss_plate   : 0,
    soup_bowl    : 0,
    big_bowl     : 0,
    mug          : 4
};

// Dirty containers waiting to be washed.
global.containers_dirty = {
    normal_plate : 0,
    big_plate    : 0,
    boss_plate   : 0,
    soup_bowl    : 0,
    big_bowl     : 0,
    mug          : 0
};

// Max container capacity.
// Upgrades will increase these later.
global.containers_capacity = {
    normal_plate : 6,
    big_plate    : 0,
    boss_plate   : 0,
    soup_bowl    : 0,
    big_bowl     : 0,
    mug          : 4
};

// Wash times in steps.
global.wash_time = {
    normal_plate : room_speed * 2,
    soup_bowl    : room_speed * 3,
    big_plate    : room_speed * 4,
    big_bowl     : room_speed * 5,
    boss_plate   : room_speed * 7,
    mug          : room_speed * 2
};

// ----------------------------------------------------
// Ingredients / stock
// ----------------------------------------------------
global.ingredients_stock = {
    skewered_rat : 12,
    bat_wings    : 8,
    bog_relish   : 10,
    bone_juice   : 10
};

global.ingredients_used_this_shift = {
    skewered_rat : 0,
    bat_wings    : 0,
    bog_relish   : 0,
    bone_juice   : 0
};

// ----------------------------------------------------
// Recipe unlocks
// ----------------------------------------------------
global.recipes_unlocked = {
    skewered_rat : true,
    bat_wings    : true,
    swamp_stew   : false,
    bat_burger   : false
};

// Basic recipe values.
global.recipe_value = {
    skewered_rat : 8,
    bat_wings    : 10,
    swamp_stew   : 12,
    bat_burger   : 15
};

// ----------------------------------------------------
// Station unlocks / upgrades
// ----------------------------------------------------
global.station_unlocked = {
    plate_holder    : true,
    prep_counter    : true,
    meat_rack       : true,
    grill           : true,
    cauldron        : false,
    butcher_block   : false,
    garnish_station : true,
    drink_barrel    : true,
    wash_station    : true,
    tool_rack       : false,
    gobble_toad     : true
};

global.station_level = {
    plate_holder    : 1,
    prep_counter    : 1,
    meat_rack       : 1,
    grill           : 1,
    cauldron        : 0,
    butcher_block   : 0,
    garnish_station : 1,
    drink_barrel    : 1,
    wash_station    : 1,
    tool_rack       : 0,
    gobble_toad     : 1
};

// Station slot counts.
// Upgrades will increase these later.
global.station_slots = {
    prep_counter : 1,
    grill        : 2,
    cauldron     : 0,
    wash_station : 1
};

// ----------------------------------------------------
// Cook / prep state names
// ----------------------------------------------------
global.cook_states = [
    "raw",
    "lightly_cooked",
    "medium_cooked",
    "well_cooked",
    "burnt",
    "ash"
];

global.cauldron_states = [
    "watery",
    "warm",
    "bubbling",
    "thick",
    "sludge",
    "ruined"
];

global.prep_states = [
    "whole",
    "chunky",
    "chopped",
    "minced",
    "paste",
    "ruined_mush"
];

// ----------------------------------------------------
// Mess / filth system
// ----------------------------------------------------
// Orc Kitchen should not aim for spotless.
// Some filth is good. Too much filth is bad.
global.filth = 25;
global.filth_min_ideal = 20;
global.filth_max_ideal = 60;
global.filth_max = 100;

global.mess_count = 0;
global.mess_created_this_shift = 0;
global.mess_cleaned_this_shift = 0;

// ----------------------------------------------------
// Damage / repair system
// ----------------------------------------------------
global.broken_station_count = 0;
global.repairs_done_this_shift = 0;

global.repair_time = {
    table        : room_speed * 2,
    plate_rack   : room_speed * 3,
    grill        : room_speed * 4,
    washer       : room_speed * 4,
    boss_rack    : room_speed * 5
};

// ----------------------------------------------------
// Boss / calendar starter
// ----------------------------------------------------
global.next_boss_day = 3;
global.next_boss_name = "General Headsmash";

global.boss_event_active = false;
global.boss_event_complete = false;

// ----------------------------------------------------
// Player / interaction helpers
// ----------------------------------------------------
global.player_can_move = true;
global.player_can_interact = true;

global.show_station_labels = false;

// Current held item is better stored on oPlayer,
// but this global is useful for debugging early on.
global.debug_player_holding = "nothing";

// ----------------------------------------------------
// Recipe Menu / Cookbook
// ----------------------------------------------------
global.recipe_menu_open = false;
global.recipe_menu_index = 0;

// Used so the recipe menu can pause the game without confusing
// the normal pause button too much.
global.recipe_menu_was_open = false;

// ----------------------------------------------------
// Shift report starter
// ----------------------------------------------------
global.shift_report_ready = false;

show_debug_message("[oGame] Orc Kitchen controller created.");