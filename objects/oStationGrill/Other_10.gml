/// oStationGrill — User Event 0
var _p = interactor;
if (_p == noone || !instance_exists(_p)) exit;

if (!has_food)
{
    var _kind = _p.held_kind;
    var _rat = (_kind == "food_rat_raw" || _kind == "food_rat_cooked"
        || _kind == "food_rat_burnt");
    var _bat = (_kind == "food_bat_wings_raw" || _kind == "food_bat_wings_cooked"
        || _kind == "food_bat_wings_burnt");
    if (!_rat && !_bat) exit;

    has_food = true;
    food_kind = _bat ? "bat_wings" : "skewered_rat";
    food_sprite = _p.held_sprite;
    food_name = _p.held_name;
    food_data = _p.held_data;

    cook_time_cooked = room_speed * (_bat ? 1.5 : 2.0);
    cook_time_burnt = room_speed * (_bat ? 3.0 : 5.0);
    cook_timer = 0;
    cook_state = "raw";

    if (!is_undefined(food_data))
    {
        if (variable_struct_exists(food_data, "cook_timer"))
            cook_timer = food_data.cook_timer;
    }
    if (string_pos("_cooked", _kind) > 0)
        cook_timer = max(cook_timer, cook_time_cooked);
    if (string_pos("_burnt", _kind) > 0)
        cook_timer = cook_time_burnt;

    // Resolve correct visual immediately.
    if (cook_timer >= cook_time_burnt)
    {
        cook_state = "burnt";
        food_sprite = _bat ? spriteFoodBatWingsBurnt : spriteFoodRatBurnt;
        food_name = _bat ? "Burnt Cave-Bat Wings" : "Burnt Skewered Rat";
    }
    else if (cook_timer >= cook_time_cooked)
    {
        cook_state = "cooked";
        food_sprite = _bat ? spriteFoodBatWingsCooked : spriteFoodRatCooked;
        food_name = _bat ? "Cooked Cave-Bat Wings" : "Cooked Skewered Rat";
    }
    else
    {
        cook_state = "raw";
        food_sprite = _bat ? spriteFoodBatWingsRaw : spriteFoodRatRaw;
        food_name = _bat ? "Raw Cave-Bat Wings" : "Raw Skewered Rat";
    }
    if (!is_undefined(food_data))
    {
        food_data.cook_timer = cook_timer;
        food_data.cook_state = cook_state;
        food_data.sprite = food_sprite;
    }

    _p.held_kind = "";
    _p.held_sprite = -1;
    _p.held_image = 0;
    _p.held_name = "";
    _p.held_is_food = false;
    _p.held_is_dirty = false;
    _p.held_is_tool = false;
    _p.held_data = undefined;
    _p.is_carrying = false;
    exit;
}

if (_p.held_kind != "") exit;

var _is_bat = (food_kind == "bat_wings");
if (is_undefined(food_data))
    food_data = { item: food_kind, component_type: "main" };
food_data.cook_timer = cook_timer;
food_data.cook_state = cook_state;
food_data.sprite = food_sprite;

var _base = _is_bat ? "food_bat_wings_" : "food_rat_";
_p.held_kind = _base + cook_state;
_p.held_sprite = food_sprite;
_p.held_image = 0;
_p.held_name = food_name;
_p.held_is_food = true;
_p.held_is_dirty = false;
_p.held_is_tool = false;
_p.held_data = food_data;
_p.is_carrying = true;

has_food = false;
food_kind = "";
food_sprite = -1;
food_name = "";
food_data = undefined;
cook_timer = 0;
cook_state = "";
