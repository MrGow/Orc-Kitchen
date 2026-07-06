/// oStationGrill — User Event 0
// Called by oPlayer interaction

var _p = interactor;
if (_p == noone || !instance_exists(_p)) exit;

// ----------------------------------------------------
// Put raw rat onto empty grill
// ----------------------------------------------------
if (!has_food)
{
    if (_p.held_kind == "food_rat_raw")
    {
        has_food = true;

        food_kind   = _p.held_kind;
        food_sprite = _p.held_sprite;
        food_name   = _p.held_name;
        food_data   = _p.held_data;

        cook_timer = 0;
        cook_state = "raw";

        _p.held_kind   = "";
        _p.held_sprite = -1;
        _p.held_image  = 0;
        _p.held_name   = "";
        _p.held_is_food = false;
        _p.held_data   = undefined;
        _p.is_carrying = false;
    }

    exit;
}

// ----------------------------------------------------
// Pick food up from grill if player is empty-handed
// ----------------------------------------------------
if (has_food && _p.held_kind == "")
{
    if (cook_state == "raw")
    {
        _p.held_kind   = "food_rat_raw";
        _p.held_sprite = spriteFoodRatRaw;
        _p.held_name   = "Raw Skewered Rat";

        if (!is_undefined(food_data))
        {
            food_data.cook_state = "raw";
            food_data.sprite = spriteFoodRatRaw;
        }
    }
    else if (cook_state == "cooked")
    {
        _p.held_kind   = "food_rat_cooked";
        _p.held_sprite = spriteFoodRatCooked;
        _p.held_name   = "Cooked Skewered Rat";

        if (!is_undefined(food_data))
        {
            food_data.cook_state = "cooked";
            food_data.sprite = spriteFoodRatCooked;
        }
    }
    else if (cook_state == "burnt")
    {
        _p.held_kind   = "food_rat_burnt";
        _p.held_sprite = spriteFoodRatBurnt;
        _p.held_name   = "Burnt Skewered Rat";

        if (!is_undefined(food_data))
        {
            food_data.cook_state = "burnt";
            food_data.sprite = spriteFoodRatBurnt;
        }
    }

    _p.held_image = 0;
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

    exit;
}