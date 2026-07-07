/// oStationGrill — User Event 0
// Called by oPlayer interaction

var _p = interactor;
if (_p == noone || !instance_exists(_p)) exit;

// ----------------------------------------------------
// Put rat meat onto empty grill
// Allows raw, cooked, or burnt rat to be placed back.
// Cook progress resumes from held_data.cook_timer.
// ----------------------------------------------------
if (!has_food)
{
    var _can_place_rat =
        _p.held_kind == "food_rat_raw"
        || _p.held_kind == "food_rat_cooked"
        || _p.held_kind == "food_rat_burnt";

    if (_can_place_rat)
    {
        has_food = true;

        food_kind   = _p.held_kind;
        food_sprite = _p.held_sprite;
        food_name   = _p.held_name;
        food_data   = _p.held_data;

        // ------------------------------------------------
        // Restore stored cook progress from the food item.
        // If no timer exists yet, start from 0.
        // ------------------------------------------------
        cook_timer = 0;
        cook_state = "raw";

        if (!is_undefined(food_data))
        {
            if (variable_struct_exists(food_data, "cook_timer"))
            {
                cook_timer = food_data.cook_timer;
            }

            if (variable_struct_exists(food_data, "cook_state"))
            {
                cook_state = food_data.cook_state;
            }
        }

        // Safety correction based on held kind.
        if (_p.held_kind == "food_rat_cooked")
        {
            if (cook_timer < cook_time_cooked)
            {
                cook_timer = cook_time_cooked;
            }

            cook_state = "cooked";
            food_sprite = spriteFoodRatCooked;
            food_name = "Cooked Skewered Rat";
        }
        else if (_p.held_kind == "food_rat_burnt")
        {
            cook_timer = cook_time_burnt;
            cook_state = "burnt";
            food_sprite = spriteFoodRatBurnt;
            food_name = "Burnt Skewered Rat";
        }
        else
        {
            // Raw/undercooked rat can still have partial cook progress.
            if (cook_timer >= cook_time_burnt)
            {
                cook_timer = cook_time_burnt;
                cook_state = "burnt";
                food_sprite = spriteFoodRatBurnt;
                food_name = "Burnt Skewered Rat";
            }
            else if (cook_timer >= cook_time_cooked)
            {
                cook_state = "cooked";
                food_sprite = spriteFoodRatCooked;
                food_name = "Cooked Skewered Rat";
            }
            else
            {
                cook_state = "raw";
                food_sprite = spriteFoodRatRaw;
                food_name = "Raw Skewered Rat";
            }
        }

        // Store corrected state back into the food data.
        if (!is_undefined(food_data))
        {
            food_data.cook_timer = cook_timer;
            food_data.cook_state = cook_state;
            food_data.sprite = food_sprite;
        }

        // Clear player hand.
        _p.held_kind     = "";
        _p.held_sprite   = -1;
        _p.held_image    = 0;
        _p.held_name     = "";
        _p.held_is_food  = false;
        _p.held_is_dirty = false;
        _p.held_is_tool  = false;
        _p.held_data     = undefined;
        _p.is_carrying   = false;
    }

    exit;
}

// ----------------------------------------------------
// Pick food up from grill if player is empty-handed
// ----------------------------------------------------
if (has_food && _p.held_kind == "")
{
    // Make sure food data exists.
    if (is_undefined(food_data))
    {
        food_data = {
            item: "skewered_rat",
            component_type: "main"
        };
    }

    // Store current cook progress inside the food before pickup.
    food_data.cook_timer = cook_timer;
    food_data.cook_state = cook_state;

    if (cook_state == "raw")
    {
        _p.held_kind   = "food_rat_raw";
        _p.held_sprite = spriteFoodRatRaw;
        _p.held_name   = "Raw Skewered Rat";

        food_data.sprite = spriteFoodRatRaw;
    }
    else if (cook_state == "cooked")
    {
        _p.held_kind   = "food_rat_cooked";
        _p.held_sprite = spriteFoodRatCooked;
        _p.held_name   = "Cooked Skewered Rat";

        food_data.sprite = spriteFoodRatCooked;
    }
    else if (cook_state == "burnt")
    {
        _p.held_kind   = "food_rat_burnt";
        _p.held_sprite = spriteFoodRatBurnt;
        _p.held_name   = "Burnt Skewered Rat";

        food_data.sprite = spriteFoodRatBurnt;
    }

    _p.held_image    = 0;
    _p.held_is_food  = true;
    _p.held_is_dirty = false;
    _p.held_is_tool  = false;
    _p.held_data     = food_data;
    _p.is_carrying   = true;

    // Clear grill.
    has_food = false;
    food_kind = "";
    food_sprite = -1;
    food_name = "";
    food_data = undefined;
    cook_timer = 0;
    cook_state = "";

    exit;
}