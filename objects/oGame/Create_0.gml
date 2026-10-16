
/// oGame — Create
// Persistent global controller for Orc Kitchen.
// Place ONE oGame in MainMenuRoom only.


// ====================================================
// PERSISTENCE / DUPLICATE PROTECTION
// ====================================================

persistent = true;

if (instance_number(oGame) > 1)
{
    instance_destroy();
    exit;
}


// ====================================================
// PIXEL ART / TEXTURE FILTERING
// ====================================================

gpu_set_texfilter(false);


// ====================================================
// BASE RESOLUTION / PRESENTATION
// ====================================================

global.GAME_W = 640;
global.GAME_H = 360;

// Base tile scale.
global.TILE_SIZE = 64;

// GUI virtual resolution.
global.GUI_W = 640;
global.GUI_H = 360;

display_set_gui_size(
    global.GUI_W,
    global.GUI_H
);

// Application surface presentation helpers.
global._appsurf_scale = 1;
global._appsurf_xoff = 0;
global._appsurf_yoff = 0;


// ====================================================
// WINDOW / FULLSCREEN
// ====================================================

global.windowed_w = 1280;
global.windowed_h = 720;

global.is_fullscreen = false;

// Start windowed during development.
window_set_fullscreen(false);

window_set_size(
    global.windowed_w,
    global.windowed_h
);

window_center();


// ====================================================
// GENERAL RUNTIME STATE
// ====================================================

global.frame = 0;

global.paused = false;

// Custom debug flag.
// Do not use global.debug_mode.
global.ok_debug = true;


// ====================================================
// MAIN MENU / CAMPAIGN STATE
// ====================================================

// oGame exists from startup, but gameplay has not
// started yet.
//
// Main states:
// "main_menu"
// "kitchen"
// "camp_map"
// "market"
// "home"

global.game_state = "main_menu";

// Campaign is initialized, but not yet running.
// Room Start will activate it when New Game
// sends the player to MessHall.
global.campaign_started = false;


// ====================================================
// DAY / SHIFT STATE
// ====================================================

// Main menu is the initial phase.
//
// Gameplay phases:
// "pre_shift"
// "serving"
// "closing"
// "shift_summary"
// "cleanup"
// "camp_map"
// "market"
// "home"

global.day_phase = "main_menu";

// Shift states:
// "pre_shift"
// "serving"
// "closing"
// "shift_summary"
// "cleanup"
// "ended"

global.shift_state = "ended";

global.day = 1;


// ====================================================
// DAY / SHIFT TIMERS
// ====================================================

// Short development values.
// Increase later for the full game.

global.pre_shift_time_limit = room_speed * 5;
global.pre_shift_timer = global.pre_shift_time_limit;

// Active cooking shift timer.
global.shift_time_limit = room_speed * 30;
global.shift_timer = global.shift_time_limit;

// ====================================================
// DAY DIFFICULTY PROFILES — EDIT THESE FIVE DAYS
// ====================================================
// duration: length of SERVING (seconds)
// minimum / maximum: randomized customer target for that day
// weights: relative share of arrivals in EARLY / MIDDLE / LATE
//   A day's total is divided between the sections based on these
//   weights, then each arrival gets a random time in its section.
//   This creates intentional rushes with natural variation.
// Windows: early 6-30%, middle 30-60%, late 60-90%.
// After Day 5, repeat Day 5 settings until more days are authored.

global.day_profiles = [
    { name: "Quiet Opening",  duration: 55,  minimum: 3,  maximum: 4,  weights: [3, 2, 1] },
    { name: "Steady Trade",   duration: 70,  minimum: 4,  maximum: 6,  weights: [2, 3, 2] },
    { name: "Lunch Rush",     duration: 85,  minimum: 6,  maximum: 8,  weights: [1, 6, 2] },
    { name: "Early Stampede", duration: 100, minimum: 8,  maximum: 10, weights: [6, 2, 2] },
    { name: "Warband Feast",  duration: 115, minimum: 10, maximum: 13, weights: [2, 3, 6] }
];

// These are rolled once when each new day's MessHall begins.
global.day_profile_name = "";
global.day_target_customers = 0;
global.day_spawn_times = [];
global.day_schedule_day = -1;
global.shift_elapsed = 0;

// Different results between game runs.
randomize();

// Summary screen.
global.summary_timer = 0;
global.summary_min_time = room_speed * 2;

// Announcement banner.
global.shift_banner_text = "";
global.shift_banner_timer = 0;

// Mess Hall exit permission.
global.can_leave_mess_hall = false;

// ====================================================
// MESS HALL TABLE OWNERSHIP
// ====================================================

// Each index corresponds to a physical table in MessHall.
//
// 0 = Small table (starting table)
// 1 = Medium table 1
// 2 = Medium table 2
// 3 = Large table 1
// 4 = Large table 2

global.tables_owned = [
    true,
    false,
    false,
    false,
    false
];

// Carpenter prices for each location.
global.table_prices = [
    0,
    25,
    40,
    65,
    90
];

// ====================================================
// ECONOMY
// ====================================================

global.gold = 0;

global.shift_revenue = 0;
global.shift_tips = 0;

global.shift_ingredient_costs = 0;
global.shift_repair_costs = 0;
global.shift_wages = 0;

global.shift_net_profit = 0;


// ====================================================
// FOOD WASTE STATISTICS
// ====================================================

// Increased by oStationGobbleToad when food
// is discarded.

global.food_wasted = 0;
global.waste_cost = 0;


// ====================================================
// CUSTOMER / ORDER TRACKING
// ====================================================

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
global.customer_queue_length = 0;
global.customer_queue_max = 6;


// ====================================================
// SATISFACTION / PATIENCE DEFAULTS
// ====================================================

global.customer_patience_max = room_speed * 45;
global.customer_queue_patience_max = room_speed * 30;

global.satisfaction_perfect = 100;
global.satisfaction_good = 75;
global.satisfaction_ok = 50;
global.satisfaction_bad = 25;
global.satisfaction_angry = 0;


// ====================================================
// PLATE / CONTAINER SYSTEM
// ====================================================

global.containers_clean =
{
    normal_plate : 6,
    big_plate    : 0,
    boss_plate   : 0,
    soup_bowl    : 0,
    big_bowl     : 0,
    mug          : 4
};

global.containers_dirty =
{
    normal_plate : 0,
    big_plate    : 0,
    boss_plate   : 0,
    soup_bowl    : 0,
    big_bowl     : 0,
    mug          : 0
};

global.containers_capacity =
{
    normal_plate : 6,
    big_plate    : 0,
    boss_plate   : 0,
    soup_bowl    : 0,
    big_bowl     : 0,
    mug          : 4
};

global.wash_time =
{
    normal_plate : room_speed * 2,
    soup_bowl    : room_speed * 3,
    big_plate    : room_speed * 4,
    big_bowl     : room_speed * 5,
    boss_plate   : room_speed * 7,
    mug          : room_speed * 2
};


// ====================================================
// INGREDIENTS / STOCK
// ====================================================

global.ingredients_stock =
{
    skewered_rat : 12,
    bat_wings    : 8,
    bog_relish   : 10,
    bone_juice   : 10
};

global.ingredients_used_this_shift =
{
    skewered_rat : 0,
    bat_wings    : 0,
    bog_relish   : 0,
    bone_juice   : 0
};


// ====================================================
// RECIPE UNLOCKS
// ====================================================

global.recipes_unlocked =
{
    skewered_rat : true,
    bat_wings    : true,
    swamp_stew   : false,
    bat_burger   : false
};

global.recipe_value =
{
    skewered_rat : 8,
    bat_wings    : 10,
    swamp_stew   : 12,
    bat_burger   : 15
};


// ====================================================
// STATION UNLOCKS / UPGRADES
// ====================================================

global.station_unlocked =
{
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

global.station_level =
{
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

global.station_slots =
{
    prep_counter : 1,
    grill        : 2,
    cauldron     : 0,
    wash_station : 1
};


// ====================================================
// COOK / PREP STATE NAMES
// ====================================================

global.cook_states =
[
    "raw",
    "lightly_cooked",
    "medium_cooked",
    "well_cooked",
    "burnt",
    "ash"
];

global.cauldron_states =
[
    "watery",
    "warm",
    "bubbling",
    "thick",
    "sludge",
    "ruined"
];

global.prep_states =
[
    "whole",
    "chunky",
    "chopped",
    "minced",
    "paste",
    "ruined_mush"
];


// ====================================================
// MESS / FILTH SYSTEM
// ====================================================

global.filth = 25;

global.filth_min_ideal = 20;
global.filth_max_ideal = 60;
global.filth_max = 100;

global.mess_count = 0;
global.mess_created_this_shift = 0;
global.mess_cleaned_this_shift = 0;


// ====================================================
// DAMAGE / REPAIR SYSTEM
// ====================================================

global.broken_station_count = 0;
global.repairs_done_this_shift = 0;

global.repair_time =
{
    table      : room_speed * 2,
    plate_rack : room_speed * 3,
    grill      : room_speed * 4,
    washer     : room_speed * 4,
    boss_rack  : room_speed * 5
};


// ====================================================
// BOSS / CALENDAR
// ====================================================

global.next_boss_day = 3;
global.next_boss_name = "General Headsmash";

global.boss_event_active = false;
global.boss_event_complete = false;


// ====================================================
// PLAYER / INTERACTION HELPERS
// ====================================================

global.player_can_move = true;
global.player_can_interact = true;

global.show_station_labels = false;

global.debug_player_holding = "nothing";


// ====================================================
// RECIPE MENU / COOKBOOK
// ====================================================

global.recipe_menu_open = false;
global.recipe_menu_index = 0;
global.recipe_menu_was_open = false;


// ====================================================
// SHIFT REPORT
// ====================================================

global.shift_report_ready = false;


// ====================================================
// INITIAL ROOM INFORMATION
// ====================================================

global.current_room = room;
global.current_room_name = room_get_name(room);


// ====================================================
// INITIALIZATION COMPLETE
// ====================================================

show_debug_message(
    "[oGame] Controller created."
);

show_debug_message(
    "[oGame] Initial state: "
    + global.game_state
);

show_debug_message(
    "[oGame] Waiting for New Game."
);
