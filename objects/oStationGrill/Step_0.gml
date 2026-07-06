/// oStationGrill — Step Event

depth = -y;

// Cooking
if (has_food)
{
    cook_timer += 1;

    if (cook_timer >= cook_time_burnt)
    {
        cook_state = "burnt";
        food_sprite = spriteFoodRatBurnt;
        food_name = "Burnt Skewered Rat";

        if (!is_undefined(food_data))
        {
            food_data.cook_state = "burnt";
            food_data.sprite = spriteFoodRatBurnt;
        }
    }
    else if (cook_timer >= cook_time_cooked)
    {
        cook_state = "cooked";
        food_sprite = spriteFoodRatCooked;
        food_name = "Cooked Skewered Rat";

        if (!is_undefined(food_data))
        {
            food_data.cook_state = "cooked";
            food_data.sprite = spriteFoodRatCooked;
        }
    }
}