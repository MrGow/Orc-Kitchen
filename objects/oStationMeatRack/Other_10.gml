/// oStationMeatRack — User Event 0
// Called by oPlayer interaction

var _p = interactor;
if (_p == noone || !instance_exists(_p)) exit;

// ----------------------------------------------------
// Return raw rat to Meat Rack
// ----------------------------------------------------
if (_p.held_kind == "food_rat_raw")
{
    stock_rat += 1;

    _p.held_kind    = "";
    _p.held_sprite  = -1;
    _p.held_image   = 0;
    _p.held_name    = "";
    _p.held_is_food = false;
    _p.held_is_dirty = false;
    _p.held_is_tool = false;
    _p.held_data    = undefined;
    _p.is_carrying  = false;

    exit;
}

// ----------------------------------------------------
// Player must be empty-handed to grab raw rat
// ----------------------------------------------------
if (_p.held_kind != "") exit;

// ----------------------------------------------------
// Grab raw skewered rat
// ----------------------------------------------------
if (stock_rat > 0)
{
    stock_rat -= 1;

    _p.held_kind   = "food_rat_raw";
    _p.held_sprite = spriteFoodRatRaw;
    _p.held_image  = 0;
    _p.held_name   = "Raw Skewered Rat";

    _p.held_is_food = true;
    _p.held_is_dirty = false;
    _p.held_is_tool = false;

    _p.held_data = {
        item: "skewered_rat",
        cook_state: "raw",
        component_type: "main",
        sprite: spriteFoodRatRaw
    };

    _p.is_carrying = true;
}