/// oGame — Draw GUI
// Temporary debug/status HUD + Recipe Book overlay.
// Later we can replace this with proper Orc Kitchen UI.

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

if (_gw <= 0) _gw = global.GUI_W;
if (_gh <= 0) _gh = global.GUI_H;

// ----------------------------------------------------
// Basic HUD
// ----------------------------------------------------
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Background panel
draw_set_color(c_black);
draw_set_alpha(0.65);
draw_rectangle(8, 8, 220, 132, false);
draw_set_alpha(1);

// Gold
draw_set_color(c_yellow);
draw_text(16, 14, "Gold: " + string(global.gold));

// Day / phase
draw_set_color(c_white);
draw_text(16, 32, "Day: " + string(global.day) + "  " + string(global.day_phase));

// Shift timer
if (
    global.day_phase == "pre_shift"
    || global.day_phase == "serving"
    || global.day_phase == "closing"
    || global.day_phase == "cleanup"
)
{
    var _time_text = "";

    if (global.day_phase == "pre_shift")
    {
        _time_text = "Starts in: " + string(ceil(global.pre_shift_timer / room_speed));
    }
    else if (global.day_phase == "serving")
    {
        _time_text = "Shift time: " + string(ceil(global.shift_timer / room_speed));
    }
    else if (global.day_phase == "closing")
    {
        _time_text = "Closing...";
    }
    else if (global.day_phase == "cleanup")
    {
        _time_text = "Cleanup / Evening";
    }

    draw_text(16, 50, _time_text);
}

// Shift revenue
draw_set_color(c_white);
draw_text(16, 68, "Shift: " + string(global.shift_revenue));

// Customers
draw_text(
    16,
    86,
    "Customers: "
    + string(global.customers_served)
    + "/"
    + string(global.customers_spawned)
);

// Active customers
draw_text(
    16,
    104,
    "Active: "
    + string(global.active_customers)
    + "/"
    + string(global.max_customers)
);

// Waste
draw_set_color(make_color_rgb(180, 255, 120));
draw_text(
    16,
    122,
    "Wasted: "
    + string(global.food_wasted)
    + "  Cost: "
    + string(global.waste_cost)
);

// ----------------------------------------------------
// Shift banner / announcement
// ----------------------------------------------------
if (global.shift_banner_timer > 0 && global.shift_banner_text != "")
{
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_set_alpha(0.78);
    draw_set_color(c_black);
    draw_rectangle(
        0,
        _gh * 0.35,
        _gw,
        _gh * 0.50,
        false
    );

    draw_set_alpha(1);
    draw_set_color(c_yellow);
    draw_text(
        _gw * 0.5,
        _gh * 0.425,
        global.shift_banner_text
    );

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
    draw_set_color(c_white);
}

// ----------------------------------------------------
// Shift summary overlay
// ----------------------------------------------------
if (global.day_phase == "shift_summary")
{
    draw_set_alpha(0.90);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);

    draw_set_color(c_yellow);
    draw_text(_gw * 0.5, 42, "SHIFT ENDED");

    draw_set_color(c_white);

    var _x = _gw * 0.5;
    var _y = 92;
    var _gap = 22;

    draw_text(_x, _y, "Gold earned: " + string(global.shift_revenue));
    _y += _gap;

    draw_text(_x, _y, "Tips: " + string(global.shift_tips));
    _y += _gap;

    draw_text(_x, _y, "Net profit: " + string(global.shift_net_profit));
    _y += _gap;

    draw_text(_x, _y, "Customers served: " + string(global.customers_served));
    _y += _gap;

    draw_text(_x, _y, "Customers failed: " + string(global.customers_failed));
    _y += _gap;

    draw_text(_x, _y, "Left angry: " + string(global.customers_left_angry));
    _y += _gap;

    draw_text(_x, _y, "Food wasted: " + string(global.food_wasted));
    _y += _gap;

    draw_text(_x, _y, "Waste cost: " + string(global.waste_cost));

    if (global.summary_timer >= global.summary_min_time)
    {
        draw_set_color(c_lime);
        draw_text(_gw * 0.5, _gh - 54, "Press Space / Enter / E to continue");
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
    draw_set_color(c_white);
    exit;
}

// ----------------------------------------------------
// Recipe Book overlay
// ----------------------------------------------------
if (global.recipe_menu_open)
{
    draw_set_alpha(0.72);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);

    var _panel_w = 520;
    var _panel_h = 300;
    var _px = (_gw - _panel_w) * 0.5;
    var _py = (_gh - _panel_h) * 0.5;

    draw_set_color(make_color_rgb(42, 26, 14));
    draw_rectangle(_px, _py, _px + _panel_w, _py + _panel_h, false);

    draw_set_color(make_color_rgb(92, 58, 28));
    draw_rectangle(_px + 6, _py + 6, _px + _panel_w - 6, _py + _panel_h - 6, true);

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);

    draw_set_color(c_yellow);
    draw_text(_gw * 0.5, _py + 18, "GREASE-STAINED WAR COOKBOOK");

    draw_set_color(c_white);
    draw_text(_gw * 0.5, _py + 50, "Skewered Rat");

    if (asset_get_index("spriteFoodFinalSkeweredRat") != -1)
    {
        draw_sprite(spriteFoodFinalSkeweredRat, 0, _gw * 0.5, _py + 98);
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    var _tx = _px + 36;
    var _ty = _py + 130;
    var _line = 20;

    draw_set_color(c_yellow);
    draw_text(_tx, _ty, "Needs:");

    draw_set_color(c_white);
    draw_text(_tx + 90, _ty, "Normal Plate, Raw Rat, Grill");

    _ty += _line + 8;

    draw_set_color(c_yellow);
    draw_text(_tx, _ty, "Steps:");

    draw_set_color(c_white);

    _ty += _line;
    draw_text(_tx + 18, _ty, "1. Grab a Clean Plate from the Plate Holder.");

    _ty += _line;
    draw_text(_tx + 18, _ty, "2. Grab Raw Skewered Rat from the Meat Rack.");

    _ty += _line;
    draw_text(_tx + 18, _ty, "3. Grill the rat until the bar reaches cooked.");

    _ty += _line;
    draw_text(_tx + 18, _ty, "4. Put Plate + Cooked Rat on the Prep Counter.");

    _ty += _line;
    draw_text(_tx + 18, _ty, "5. Smoke pop = finished Skewered Rat.");

    _ty += _line;
    draw_text(_tx + 18, _ty, "6. Serve it to the correct customer table seat.");

    draw_set_halign(fa_center);
    draw_set_color(c_gray);
    draw_text(_gw * 0.5, _py + _panel_h - 30, "Press R / Xbox Select to close");

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
    draw_set_color(c_white);
    exit;
}

// ----------------------------------------------------
// Pause overlay
// ----------------------------------------------------
if (global.paused)
{
    draw_set_alpha(0.55);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(_gw * 0.5, _gh * 0.5, "PAUSED");

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
    draw_set_color(c_white);
    exit;
}

// ----------------------------------------------------
// Reset draw state
// ----------------------------------------------------
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_set_color(c_white);