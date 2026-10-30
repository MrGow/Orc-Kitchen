/// oStationPrepCounter — User Event 0 (FULL EVENT)
/// Ticket-directed instant poof: plate + correct cooked ingredient.
/// Ticket is locked once an ingredient is placed.
var _p = interactor;
if (_p == noone || !instance_exists(_p)) exit;

var _controller = noone;
if (instance_exists(oOrderTicketController))
    _controller = instance_find(oOrderTicketController,0);

// An active ticket is required to BEGIN preparation.
var _active_ticket = -1;
var _active_recipe = "";
if (instance_exists(_controller))
{
    _active_ticket = _controller.selected_id;
    for (var _a=0;_a<array_length(_controller.tickets);_a++)
    {
        var _candidate = _controller.tickets[_a];
        if (_candidate.ticket_id == _active_ticket && _candidate.status == "waiting")
        {
            _active_recipe = _candidate.recipe;
            break;
        }
    }
}

function __clear_player_hand(_chef)
{
    _chef.held_kind = "";
    _chef.held_sprite = -1;
    _chef.held_image = 0;
    _chef.held_name = "";
    _chef.held_is_food = false;
    _chef.held_is_dirty = false;
    _chef.held_is_tool = false;
    _chef.held_data = undefined;
    _chef.is_carrying = false;
}

function __give_to_player(_chef,_kind,_sp,_name,_data,_food)
{
    _chef.held_kind = _kind;
    _chef.held_sprite = _sp;
    _chef.held_image = 0;
    _chef.held_name = _name;
    _chef.held_is_food = _food;
    _chef.held_is_dirty = false;
    _chef.held_is_tool = false;
    _chef.held_data = _data;
    _chef.is_carrying = true;
}

function __refresh_assignment()
{
    if (!has_plate && !has_component)
    {
        assigned_ticket_id = -1;
        assigned_recipe = "";
    }
}

function __try_assemble(_ticket_controller)
{
    if (!has_plate || !has_component || finished) return;
    if (assigned_ticket_id == -1 || !instance_exists(_ticket_controller)) return;

    var _match = undefined;
    for (var _i=0;_i<array_length(_ticket_controller.tickets);_i++)
    {
        var _t = _ticket_controller.tickets[_i];
        if (_t.ticket_id == assigned_ticket_id && _t.status == "waiting")
        {
            _match = _t;
            break;
        }
    }
    if (is_undefined(_match)) return;

    var _is_rat = component_kind == "food_rat_cooked" || component_kind == "food_rat_burnt";
    var _is_bat = component_kind == "food_bat_wings_cooked" || component_kind == "food_bat_wings_burnt";
    var _recipe = _is_rat ? "skewered_rat" : (_is_bat ? "bat_wings" : "");
    if (_recipe == "" || _recipe != _match.recipe) return;
    if (_match.topping != "") return; // Future relish requirement.

    var _burnt = string_pos("_burnt",component_kind)>0;
    var _normal_kind = _is_bat ? "meal_bat_wings" : "meal_skewered_rat";
    var _name = _is_bat ? "Charred Cave-Bat Wings" : "Skewered Rat";
    var _normal_sprite = _is_bat ? spriteFoodFinalBatWings : spriteFoodFinalSkeweredRat;
    var _burnt_sprite = _is_bat ? spriteFoodFinalBatWingsBurnt : spriteFoodFinalSkeweredRatBurnt;

    finished = true;
    finished_kind = _normal_kind + (_burnt ? "_burnt" : "");
    finished_sprite = _burnt ? _burnt_sprite : _normal_sprite;
    finished_name = (_burnt ? "Burnt " : "") + _name;
    finished_data = {
        recipe:_recipe,
        container:"plate_regular",
        cook_state:_burnt ? "burnt" : "cooked",
        topping:"",
        quality:_burnt ? 0.35 : 1.0,
        sprite:finished_sprite,
        source_ticket_id:assigned_ticket_id
    };
    if (object_exists(oFXSmokePop))
        instance_create_depth(x,y-36,depth-10,oFXSmokePop);
    finish_lock_timer = 8;

    // Stamp current ticket PREPARED, let the others slide forward.
    _match.status = "prepared";
    _match.exit_timer = 0;
    if (_ticket_controller.selected_id == assigned_ticket_id)
        _ticket_controller.selected_id = -1; // Step selects first remaining pending ticket.
    assigned_ticket_id = -1;
    assigned_recipe = "";
}

// ----------------------------------------------------
// Take finished dish.
// ----------------------------------------------------
if (finished)
{
    if (finish_lock_timer <= 0 && _p.held_kind == "")
    {
        __give_to_player(_p,finished_kind,finished_sprite,finished_name,finished_data,true);
        has_plate = false;
        plate_kind = "";
        plate_sprite = -1;
        plate_name = "";
        plate_data = undefined;
        has_component = false;
        component_kind = "";
        component_sprite = -1;
        component_name = "";
        component_data = undefined;
        finished = false;
        finished_kind = "";
        finished_sprite = -1;
        finished_name = "";
        finished_data = undefined;
    }
    exit;
}

// ----------------------------------------------------
// Empty-handed: always permit removal so nothing softlocks.
// If both plate and meat present, remove meat first.
// ----------------------------------------------------
if (_p.held_kind == "")
{
    if (has_component)
    {
        __give_to_player(_p,component_kind,component_sprite,component_name,component_data,true);
        has_component = false;
        component_kind = "";
        component_sprite = -1;
        component_name = "";
        component_data = undefined;
        __refresh_assignment();
        exit;
    }
    if (has_plate)
    {
        __give_to_player(_p,plate_kind,plate_sprite,plate_name,plate_data,false);
        has_plate = false;
        plate_kind = "";
        plate_sprite = -1;
        plate_name = "";
        plate_data = undefined;
        __refresh_assignment();
        exit;
    }
    exit;
}

// ----------------------------------------------------
// First component binds the counter to the selected ticket.
// Afterwards the assignment is NOT changed by ticket navigation.
// ----------------------------------------------------
if (assigned_ticket_id == -1)
{
    if (_active_ticket == -1 || _active_recipe == "") exit;
    if (has_plate || has_component) exit; // Cannot hijack abandoned partial prep.
}

if (!has_plate && _p.held_kind == "plate_clean")
{
    if (assigned_ticket_id == -1)
    {
        assigned_ticket_id = _active_ticket;
        assigned_recipe = _active_recipe;
    }
    has_plate = true;
    plate_kind = _p.held_kind;
    plate_sprite = _p.held_sprite;
    plate_name = _p.held_name;
    plate_data = _p.held_data;
    __clear_player_hand(_p);
    __try_assemble(_controller);
    exit;
}

var _valid_food = _p.held_kind == "food_rat_cooked"
    || _p.held_kind == "food_rat_burnt"
    || _p.held_kind == "food_bat_wings_cooked"
    || _p.held_kind == "food_bat_wings_burnt";
if (!has_component && _valid_food)
{
    if (assigned_ticket_id == -1)
    {
        assigned_ticket_id = _active_ticket;
        assigned_recipe = _active_recipe;
    }
    has_component = true;
    component_kind = _p.held_kind;
    component_sprite = _p.held_sprite;
    component_name = _p.held_name;
    component_data = _p.held_data;
    component_bob = random(1000);
    __clear_player_hand(_p);
    __try_assemble(_controller);
    exit;
}
