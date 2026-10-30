/// oSupplyMenuController — Step
/// Only the menu handles controls while open.

if (room != MessHall || !instance_exists(source_station)
    || !instance_exists(source_player))
{
    instance_destroy();
    exit;
}

if (global.paused) exit;

menu_age += 1;
menu_anim += 0.065;

// Build available choices from the source station's actual stock.
// Items are refreshed each frame, so future stock/unlocks can be dynamic.
items = [];
if (source_type == "meat")
{
    if (source_station.stock_rat > 0)
    {
        array_push(items, {
            key: "rat", name: "RAW RAT", sprite: spriteFoodRatRaw,
            stock: source_station.stock_rat
        });
    }
    if (source_station.stock_bat > 0)
    {
        array_push(items, {
            key: "bat", name: "CAVE-BAT WINGS", sprite: spriteFoodBatWingsRaw,
            stock: source_station.stock_bat
        });
    }
}
else if (source_type == "plate")
{
    if (source_station.clean_plates > 0)
    {
        array_push(items, {
            key: "plate", name: "CLEAN PLATE", sprite: spritePlateRegular,
            stock: source_station.clean_plates
        });
    }
}

var _count = array_length(items);
if (_count == 0)
{
    instance_destroy();
    exit;
}
selected = clamp(selected, 0, _count - 1);

// Ignore the opening interaction for a few frames.
if (menu_age <= menu_lock_frames) exit;

// Keyboard/controller navigation already includes stick repeat in oInput.
var _left = keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"));
var _right = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"));

if (variable_global_exists("input_left_pressed")) _left = _left || global.input_left_pressed;
if (variable_global_exists("input_right_pressed")) _right = _right || global.input_right_pressed;

if (_left && !_right) selected = (selected + _count - 1) mod _count;
if (_right && !_left) selected = (selected + 1) mod _count;

var _confirm = keyboard_check_pressed(ord("E"))
    || keyboard_check_pressed(vk_enter)
    || keyboard_check_pressed(vk_space);
var _cancel = keyboard_check_pressed(vk_escape)
    || keyboard_check_pressed(vk_backspace);

if (variable_global_exists("input_confirm_pressed"))
    _confirm = _confirm || global.input_confirm_pressed;
if (variable_global_exists("input_back_pressed"))
    _cancel = _cancel || global.input_back_pressed;

if (_cancel)
{
    // Suppress the same ESC press in oGame even if this instance
    // runs before oGame on the closing frame.
    global.supply_menu_open = true;
    keyboard_clear(vk_escape);
    instance_destroy();
    exit;
}

if (!_confirm) exit;

// A menu may have stayed open while the world updated; validate again.
var _p = source_player;
var _st = source_station;
if (_p.held_kind != "")
{
    instance_destroy();
    exit;
}

var _choice = items[selected].key;

if (source_type == "meat")
{
    if (_choice == "rat" && _st.stock_rat > 0)
    {
        _st.stock_rat -= 1;
        _p.held_kind = "food_rat_raw";
        _p.held_sprite = spriteFoodRatRaw;
        _p.held_name = "Raw Skewered Rat";
        _p.held_data = {
            item: "skewered_rat", component_type: "main", cook_state: "raw",
            cook_timer: 0, sprite: spriteFoodRatRaw
        };
    }
    else if (_choice == "bat" && _st.stock_bat > 0)
    {
        _st.stock_bat -= 1;
        _p.held_kind = "food_bat_wings_raw";
        _p.held_sprite = spriteFoodBatWingsRaw;
        _p.held_name = "Raw Cave-Bat Wings";
        _p.held_data = {
            item: "bat_wings", component_type: "main", cook_state: "raw",
            cook_timer: 0, sprite: spriteFoodBatWingsRaw
        };
    }
}
else if (source_type == "plate")
{
    if (_choice == "plate" && _st.clean_plates > 0)
    {
        _st.clean_plates -= 1;
        _p.held_kind = "plate_clean";
        _p.held_sprite = spritePlateRegular;
        _p.held_name = "Clean Plate";
        _p.held_data = {
            container: "plate_regular", clean: true, dirty: false, components: []
        };
    }
}

if (_p.held_kind != "")
{
    _p.held_image = 0;
    _p.held_is_food = (source_type == "meat");
    _p.held_is_dirty = false;
    _p.held_is_tool = false;
    _p.is_carrying = true;
}

instance_destroy();
