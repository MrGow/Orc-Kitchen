/// oGame — Draw GUI
// Temporary debug/status HUD.
// Later we can replace this with proper Orc Kitchen UI.

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

if (_gw <= 0) _gw = global.GUI_W;
if (_gh <= 0) _gh = global.GUI_H;

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
    exit;
}

// ----------------------------------------------------
// Debug HUD
// ----------------------------------------------------
if (global.debug_mode)
{
    var _x = 8;
    var _y = 8;
    var _line = 12;

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    // Backing box.
    draw_set_alpha(0.65);
    draw_set_color(c_black);
    draw_rectangle(_x - 4, _y - 4, _x + 210, _y + 132, false);
    draw_set_alpha(1);

    draw_set_color(c_white);

    draw_text(_x, _y, "ORC KITCHEN DEV HUD");
    _y += _line;

    draw_text(_x, _y, "Room: " + global.current_room_name);
    _y += _line;

    draw_text(_x, _y, "Game: " + string(global.game_state));
    _y += _line;

    draw_text(_x, _y, "Shift: " + string(global.shift_state));
    _y += _line;

    draw_text(_x, _y, "Day: " + string(global.day));
    _y += _line;

    draw_text(_x, _y, "Gold: " + string(global.gold));
    _y += _line;

    draw_text(_x, _y, "Customers: " + string(global.active_customers) + " / " + string(global.max_customers));
    _y += _line;

    draw_text(_x, _y, "Queue: " + string(global.customer_queue_length) + " / " + string(global.customer_queue_max));
    _y += _line;

    draw_text(_x, _y, "Orders done: " + string(global.orders_completed));
    _y += _line;

    draw_text(_x, _y, "Filth: " + string(global.filth));
    _y += _line;

    draw_text(_x, _y, "Holding: " + string(global.debug_player_holding));
    _y += _line;

    draw_set_color(c_yellow);
    draw_text(_x, _y, "1 Start | 2 End | 3 Gold | 4/5 Filth");
}

// ----------------------------------------------------
// Small day/coin display placeholder
// ----------------------------------------------------
draw_set_halign(fa_right);
draw_set_valign(fa_top);

draw_set_alpha(0.65);
draw_set_color(c_black);
draw_rectangle(_gw - 118, 4, _gw - 4, 34, false);
draw_set_alpha(1);

draw_set_color(c_white);
draw_text(_gw - 10, 10, "Day " + string(global.day) + "   " + string(global.gold) + "g");

draw_set_halign(fa_left);
draw_set_valign(fa_top);