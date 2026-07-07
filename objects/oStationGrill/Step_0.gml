/// oStationGrill — Step Event

if (global.paused) exit;

depth = -y;

if (has_food)
{
    // Burnt food cannot go further.
    if (cook_state != "burnt")
    {
        cook_timer += 1;
    }

    // Burnt state
    if (cook_timer >= cook_time_burnt)
    {
        cook_timer = cook_time_burnt;
        cook_state = "burnt";
        food_sprite = spriteFoodRatBurnt;
        food_name = "Burnt Skewered Rat";

        if (!is_undefined(food_data))
        {
            food_data.cook_timer = cook_timer;
            food_data.cook_state = "burnt";
            food_data.sprite = spriteFoodRatBurnt;
        }
    }

    // Cooked state
    else if (cook_timer >= cook_time_cooked)
    {
        cook_state = "cooked";
        food_sprite = spriteFoodRatCooked;
        food_name = "Cooked Skewered Rat";

        if (!is_undefined(food_data))
        {
            food_data.cook_timer = cook_timer;
            food_data.cook_state = "cooked";
            food_data.sprite = spriteFoodRatCooked;
        }
    }

    // Raw / undercooked state
    else
    {
        cook_state = "raw";
        food_sprite = spriteFoodRatRaw;
        food_name = "Raw Skewered Rat";

        if (!is_undefined(food_data))
        {
            food_data.cook_timer = cook_timer;
            food_data.cook_state = "raw";
            food_data.sprite = spriteFoodRatRaw;
        }
    }
}