/// oStationMeatRack — User Event 0
var _p = interactor;
if (_p == noone || !instance_exists(_p)) exit;
if (instance_exists(oSupplyMenuController)) exit;

// Return raw ingredients (not partially cooked ones).
var _return_rat = (_p.held_kind == "food_rat_raw");
var _return_bat = (_p.held_kind == "food_bat_wings_raw");

if (_return_rat || _return_bat)
{
    var _is_uncooked = true;
    if (!is_undefined(_p.held_data) && variable_struct_exists(_p.held_data, "cook_timer"))
        _is_uncooked = (_p.held_data.cook_timer <= 0);

    if (_is_uncooked)
    {
        if (_return_rat) stock_rat += 1;
        if (_return_bat) stock_bat += 1;

        _p.held_kind = "";
        _p.held_sprite = -1;
        _p.held_image = 0;
        _p.held_name = "";
        _p.held_is_food = false;
        _p.held_is_dirty = false;
        _p.held_is_tool = false;
        _p.held_data = undefined;
        _p.is_carrying = false;
    }
    exit;
}

if (_p.held_kind != "") exit;

global.supply_menu_open = true;
var _menu = instance_create_depth(0, 0, -1000, oSupplyMenuController);
_menu.source_station = id;
_menu.source_player = _p;
_menu.source_type = "meat";
