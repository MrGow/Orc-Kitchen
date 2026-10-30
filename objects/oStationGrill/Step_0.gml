/// oStationGrill — Step
if (global.paused) exit;
depth = -y;
if (!has_food) exit;

// Different timing for each meat; both are held in cook_timer.
var _bat = (food_kind == "bat_wings");
cook_time_cooked = room_speed * (_bat ? 1.5 : 2.0);
cook_time_burnt = room_speed * (_bat ? 3.0 : 5.0);

if (cook_state != "burnt") cook_timer += 1;

var _prefix = _bat ? "Cave-Bat Wings" : "Skewered Rat";
var _sprite_raw = _bat ? spriteFoodBatWingsRaw : spriteFoodRatRaw;
var _sprite_cooked = _bat ? spriteFoodBatWingsCooked : spriteFoodRatCooked;
var _sprite_burnt = _bat ? spriteFoodBatWingsBurnt : spriteFoodRatBurnt;

if (cook_timer >= cook_time_burnt)
{
    cook_timer = cook_time_burnt;
    cook_state = "burnt";
    food_sprite = _sprite_burnt;
    food_name = "Burnt " + _prefix;
}
else if (cook_timer >= cook_time_cooked)
{
    cook_state = "cooked";
    food_sprite = _sprite_cooked;
    food_name = "Cooked " + _prefix;
}
else
{
    cook_state = "raw";
    food_sprite = _sprite_raw;
    food_name = "Raw " + _prefix;
}

if (!is_undefined(food_data))
{
    food_data.cook_timer = cook_timer;
    food_data.cook_state = cook_state;
    food_data.sprite = food_sprite;
}
