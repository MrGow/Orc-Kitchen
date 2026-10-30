/// oOrderTicketController — Step (FULL EVENT)
/// Seated customers -> FIFO tickets; Q/E navigation;
/// prepare animation, abandoned orders and automatic advancement.

if (room != MessHall) exit;
if (global.paused) exit;

controller_frame++;
if (locked_notice > 0) locked_notice--;

// ----------------------------------------------------
// Register tickets when a customer has reached their seat.
// Customer's own Create supplies order_recipe/name/sprite.
// ----------------------------------------------------
if (global.day_phase == "serving" || global.day_phase == "closing")
{
    var _n = instance_number(oCustomer);
    for (var _i = 0; _i < _n; _i++)
    {
        var _c = instance_find(oCustomer, _i);
        if (!instance_exists(_c)) continue;
        if (_c.state != "seated") continue;
        if (!variable_instance_exists(_c,"ticket_id")) _c.ticket_id = -1;
        if (_c.ticket_id != -1) continue;

        var _new_id = next_number++;
        _c.ticket_id = _new_id;
        var _t = {
            ticket_id: _new_id,
            customer: _c,
            recipe: _c.order_recipe,
            name: _c.order_name,
            sprite: _c.order_sprite,
            cook_state: _c.order_cook_state,
            topping: "",
            status: "waiting", // waiting -> prepared -> slide out
            exit_timer: 0,
            gui_x: 660,
            gui_y: rail_y + 7
        };
        array_push(tickets, _t);
        if (selected_id == -1) selected_id = _new_id;
    }
}

// ----------------------------------------------------
// Mark departing customers as abandoned; prepared tickets
// can finish sliding away normally.
// ----------------------------------------------------
for (var _j = array_length(tickets)-1; _j >= 0; _j--)
{
    var _t = tickets[_j];
    if (_t.status == "waiting")
    {
        if (!instance_exists(_t.customer)) _t.status = "abandoned";
        else if (_t.customer.state == "leaving" || _t.customer.state == "eating")
            _t.status = "abandoned";
    }
    if (_t.status == "abandoned")
    {
        if (_t.ticket_id == selected_id) selected_id = -1;
        array_delete(tickets,_j,1);
    }
}

// Keep a prepared ticket briefly for the giant check animation.
for (var _k = array_length(tickets)-1; _k >= 0; _k--)
{
    var _ticket = tickets[_k];
    if (_ticket.status == "prepared")
    {
        _ticket.exit_timer++;
        if (_ticket.exit_timer >= 34)
            array_delete(tickets,_k,1);
    }
}

// Find pending tickets in the current display order.
var _waiting = [];
for (var _m = 0; _m < array_length(tickets); _m++)
    if (tickets[_m].status == "waiting") array_push(_waiting,tickets[_m]);

var _selected_index = -1;
for (var _a=0; _a<array_length(_waiting); _a++)
    if (_waiting[_a].ticket_id == selected_id) { _selected_index = _a; break; }

if (_selected_index == -1)
{
    selected_id = array_length(_waiting)>0 ? _waiting[0].ticket_id : -1;
    _selected_index = array_length(_waiting)>0 ? 0 : -1;
}

// ----------------------------------------------------
// Prep Counter locks ticket changes while partly filled.
// A finished dish does not lock selection.
// ----------------------------------------------------
var _counter_busy = false;
if (instance_exists(oStationPrepCounter))
{
    var _prep = instance_find(oStationPrepCounter,0);
    _counter_busy = !_prep.finished && (_prep.has_plate || _prep.has_component);
}

var _picker = instance_exists(oSupplyMenuController);
var _pause_ui = variable_global_exists("pause_menu_open") && global.pause_menu_open;
var _book_ui = global.recipe_menu_open;
var _can_navigate = !_picker && !_pause_ui && !_book_ui
    && (global.day_phase == "serving" || global.day_phase == "closing")
    && array_length(_waiting)>1;

if (_can_navigate)
{
    var _prev = keyboard_check_pressed(ord("Q"));
    var _next = keyboard_check_pressed(ord("E"));
    var _gp = 0;
    if (gamepad_is_connected(_gp))
    {
        _prev = _prev || gamepad_button_check_pressed(_gp,gp_shoulderl);
        _next = _next || gamepad_button_check_pressed(_gp,gp_shoulderr);
    }
    if (_prev != _next)
    {
        if (_counter_busy)
        {
            locked_notice = room_speed;
        }
        else
        {
            var _new_index = (_selected_index + (_next ? 1 : -1) + array_length(_waiting)) mod array_length(_waiting);
            selected_id = _waiting[_new_index].ticket_id;
        }
    }
}

// ----------------------------------------------------
// Animate selected ticket first, followed by remaining tickets
// in arrival order. New tickets slide in from screen right.
// ----------------------------------------------------
var _arranged = [];
if (selected_id != -1)
{
    for (var _v=0;_v<array_length(_waiting);_v++)
        if (_waiting[_v].ticket_id == selected_id)
            array_push(_arranged,_waiting[_v]);
}
for (var _z=0;_z<array_length(_waiting);_z++)
    if (_waiting[_z].ticket_id != selected_id)
        array_push(_arranged,_waiting[_z]);

var _target_x = slot_first_x;
for (var _b=0;_b<array_length(_arranged);_b++)
{
    var _entry = _arranged[_b];
    _entry.gui_x = lerp(_entry.gui_x,_target_x,slide_speed);
    _entry.gui_y = lerp(_entry.gui_y,rail_y + (_b == 0 ? -7 : 7),slide_speed);
    _target_x += (_b==0 ? slot_selected_w : slot_normal_w)+slot_gap;
}
for (var _cidx=0;_cidx<array_length(tickets);_cidx++)
{
    var _exit_t = tickets[_cidx];
    if (_exit_t.status == "prepared")
    {
        _exit_t.gui_x = lerp(_exit_t.gui_x,-205,0.16);
    }
}
