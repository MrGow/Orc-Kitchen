/// oStationGobbleToad — User Event 0
// Called by oPlayer interaction

var _p = interactor;
if (_p == noone || !instance_exists(_p)) exit;

// Must be carrying something.
if (!_p.is_carrying || _p.held_kind == "") exit;

// ----------------------------------------------------
// Decide what the Gobble-Toad is allowed to eat.
// For now: food and finished meals only.
// Do NOT eat plates yet, to avoid breaking the plate loop.
// ----------------------------------------------------
var _can_eat = false;

// General food flag
if (_p.held_is_food)
{
    _can_eat = true;
}

// Safety: explicit known food kinds
if (_p.held_kind == "food_rat_raw") _can_eat = true;
if (_p.held_kind == "food_rat_cooked") _can_eat = true;
if (_p.held_kind == "food_rat_burnt") _can_eat = true;
if (_p.held_kind == "meal_skewered_rat") _can_eat = true;
if (_p.held_kind == "meal_skewered_rat_burnt") _can_eat = true;

// Do not eat clean/dirty plates.
if (_p.held_kind == "plate_clean") _can_eat = false;
if (_p.held_kind == "plate_dirty") _can_eat = false;

if (!_can_eat)
{
    gobble_text = "NO PLATE!";
    gobble_text_timer = room_speed;
    exit;
}

// ----------------------------------------------------
// Optional: track waste value
// ----------------------------------------------------
food_eaten += 1;

if (_p.held_kind == "meal_skewered_rat")
{
    waste_value += 8;
}
else if (_p.held_kind == "meal_skewered_rat_burnt")
{
    waste_value += 3;
}
else
{
    waste_value += 1;
}

// Optional global waste stats
if (!variable_global_exists("food_wasted"))
{
    global.food_wasted = 0;
}

if (!variable_global_exists("waste_cost"))
{
    global.waste_cost = 0;
}

global.food_wasted += 1;
global.waste_cost += 1;

// ----------------------------------------------------
// Eat it
// ----------------------------------------------------
gobble_timer = 12;
gobble_text = "CHOMP!";
gobble_text_timer = room_speed * 1;

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