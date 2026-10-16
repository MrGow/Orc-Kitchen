/// oGame — Room Start
// Refresh room references and prepare a new day's spawn schedule.

game_set_speed(60, gamespeed_fps);
gpu_set_texfilter(false);
display_set_gui_size(global.GUI_W, global.GUI_H);

// ====================================================
// LAYERS
// ====================================================
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

// ====================================================
// TILEMAP REFERENCES
// ====================================================
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

if (!variable_global_exists("closing_timer"))
    global.closing_timer = 0;

// ====================================================
// ROOM STATE
// ====================================================
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

    if (!global.campaign_started)
    {
        global.campaign_started = true;
        global.day_phase = "pre_shift";
        global.shift_state = "pre_shift";
        global.pre_shift_timer = global.pre_shift_time_limit;
        global.shift_banner_text = "";
        global.shift_banner_timer = 0;
    }

    // Returning to the mess hall from the camp map should
    // restore cleanup, NOT accidentally resume a shift.
    // Sleeping sets pre_shift before changing rooms, so it is safe.
    if (global.day_phase == "camp_map"
        || global.day_phase == "market"
        || global.day_phase == "home")
    {
        global.day_phase = "cleanup";
    }

    // ------------------------------------------------
    // BUILD TODAY'S ARRIVAL SCHEDULE — ONCE PER DAY
    // ------------------------------------------------
    if (global.day_phase == "pre_shift"
        && global.day_schedule_day != global.day)
    {
        var _profile_index = clamp(global.day - 1, 0,
            array_length(global.day_profiles) - 1);
        var _profile = global.day_profiles[_profile_index];

        global.day_profile_name = _profile.name;
        global.day_target_customers = irandom_range(
            _profile.minimum, _profile.maximum);

        // Serving time, not including the 5-second countdown.
        global.shift_time_limit = room_speed * _profile.duration;
        global.shift_timer = global.shift_time_limit;
        global.shift_elapsed = 0;
        global.closing_timer = 0;

        // Each customer gets a scheduled timestamp (in frames
        // since the start of serving). The three windows cover:
        // EARLY 6-30%, MIDDLE 30-60%, LATE 60-90%.
        var _windows = [
            { start: 0.06, finish: 0.30 },
            { start: 0.30, finish: 0.60 },
            { start: 0.60, finish: 0.90 }
        ];

        var _weight_total = 0;
        for (var _w = 0; _w < 3; _w++)
            _weight_total += max(0, _profile.weights[_w]);

        if (_weight_total <= 0)
            _weight_total = 3;

        // Assign a predictable SHARE of customers to each window.
        // The total is still randomized and exact timings are random.
        var _counts = [0, 0, 0];
        var _fractions = [0, 0, 0];
        var _assigned = 0;

        for (var _section = 0; _section < 3; _section++)
        {
            var _weight = max(0, _profile.weights[_section]);
            if (_weight_total == 3
                && _profile.weights[0] <= 0
                && _profile.weights[1] <= 0
                && _profile.weights[2] <= 0)
                _weight = 1;

            var _ideal = global.day_target_customers * _weight / _weight_total;
            _counts[_section] = floor(_ideal);
            _fractions[_section] = _ideal - _counts[_section];
            _assigned += _counts[_section];
        }

        // Allocate rounding remainders, randomly breaking close ties.
        while (_assigned < global.day_target_customers)
        {
            var _best = 0;
            var _best_score = -100;

            for (var _k = 0; _k < 3; _k++)
            {
                var _score = _fractions[_k] + random(0.08);
                if (_score > _best_score)
                {
                    _best_score = _score;
                    _best = _k;
                }
            }

            _counts[_best] += 1;
            _fractions[_best] = -1;
            _assigned += 1;
        }

        global.day_spawn_times = [];

        for (var _part = 0; _part < 3; _part++)
        {
            var _window = _windows[_part];

            for (var _c = 0; _c < _counts[_part]; _c++)
            {
                var _fraction = random_range(_window.start, _window.finish);
                var _spawn_frame = round(global.shift_time_limit * _fraction);
                array_push(global.day_spawn_times, _spawn_frame);
            }
        }

        // Order arrivals chronologically. Spread identical/nearby
        // timestamps out by 1.5 seconds so nobody piles up instantly.
        array_sort(global.day_spawn_times, true);
        var _minimum_gap = max(1, round(room_speed * 1.5));
        var _last_frame = 0;

        for (var _i = 0; _i < array_length(global.day_spawn_times); _i++)
        {
            var _scheduled = max(global.day_spawn_times[_i],
                _last_frame + _minimum_gap);

            // Any arrivals exceeding this time cannot spawn before
            // Last Call; the current five profiles have ample time.
            _scheduled = min(_scheduled,
                global.shift_time_limit - round(room_speed * 2));

            global.day_spawn_times[_i] = _scheduled;
            _last_frame = _scheduled;
        }

        global.day_schedule_day = global.day;

        show_debug_message("[oGame] DAY " + string(global.day)
            + " — " + global.day_profile_name
            + " — " + string(global.day_target_customers)
            + " customers across " + string(_profile.duration)
            + " seconds.");

        if (global.ok_debug)
        {
            for (var _j = 0; _j < array_length(global.day_spawn_times); _j++)
            {
                show_debug_message("  Arrival " + string(_j + 1)
                    + ": " + string_format(
                        global.day_spawn_times[_j] / room_speed, 0, 1)
                    + "s");
            }
        }
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

// ====================================================
// PER-ROOM FLAGS
// ====================================================
global.show_station_labels = false;
global.player_can_move = (room != MainMenuRoom);
global.player_can_interact = (room != MainMenuRoom);

show_debug_message("[oGame] Room Start: " + global.current_room_name);
