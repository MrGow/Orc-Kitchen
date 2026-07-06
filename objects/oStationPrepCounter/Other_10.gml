/// oStationPrepCounter — User Event 0
// Called by oPlayer interaction

var _p = interactor;
if (_p == noone || !instance_exists(_p)) exit;

// ----------------------------------------------------
// If finished food is ready, player can pick it up
// ----------------------------------------------------
if (finished)
{
    if (finish_lock_timer <= 0 && _p.held_kind == "")
    {
        _p.held_kind    = finished_kind;
        _p.held_sprite  = finished_sprite;
        _p.held_image   = 0;
        _p.held_name    = finished_name;
        _p.held_is_food = true;
        _p.held_is_dirty = false;
        _p.held_is_tool = false;
        _p.held_data    = finished_data;
        _p.is_carrying  = true;

        // Clear counter
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
// Place clean plate on empty counter
// ----------------------------------------------------
if (!has_plate)
{
    if (_p.held_kind == "plate_clean")
    {
        has_plate = true;

        plate_kind   = _p.held_kind;
        plate_sprite = _p.held_sprite;
        plate_name   = _p.held_name;
        plate_data   = _p.held_data;

        _p.held_kind   = "";
        _p.held_sprite = -1;
        _p.held_image  = 0;
        _p.held_name   = "";
        _p.held_data   = undefined;
        _p.is_carrying = false;
    }

    exit;
}

// ----------------------------------------------------
// Add cooked or burnt rat component to plate/counter
// ----------------------------------------------------
if (has_plate && !has_component)
{
    if (_p.held_kind == "food_rat_cooked" || _p.held_kind == "food_rat_burnt")
    {
        has_component = true;

        component_kind   = _p.held_kind;
        component_sprite = _p.held_sprite;
        component_name   = _p.held_name;
        component_data   = _p.held_data;
        component_bob    = random(1000);

        _p.held_kind    = "";
        _p.held_sprite  = -1;
        _p.held_image   = 0;
        _p.held_name    = "";
        _p.held_is_food = false;
        _p.held_data    = undefined;
        _p.is_carrying  = false;

        // ------------------------------------------------
        // Recipe check: Cooked Skewered Rat
        // ------------------------------------------------
        if (component_kind == "food_rat_cooked")
        {
            if (object_exists(oFXSmokePop))
            {
                // Use depth, not layer.
                // This avoids "specified layer (-1) does not exist".
                instance_create_depth(x, y - 36, depth - 10, oFXSmokePop);
            }

            finished = true;
            finished_kind = "meal_skewered_rat";
            finished_sprite = spriteFoodFinalSkeweredRat;
            finished_name = "Skewered Rat";

            finished_data = {
                recipe: "skewered_rat",
                container: "plate_regular",
                cook_state: "cooked",
                topping: "",
                quality: 1.0,
                sprite: spriteFoodFinalSkeweredRat
            };

            finish_lock_timer = 8;
        }

        // ------------------------------------------------
        // Recipe check: Burnt Skewered Rat
        // ------------------------------------------------
        else if (component_kind == "food_rat_burnt")
        {
            if (object_exists(oFXSmokePop))
            {
                // Use depth, not layer.
                // This avoids "specified layer (-1) does not exist".
                instance_create_depth(x, y - 36, depth - 10, oFXSmokePop);
            }

            finished = true;
            finished_kind = "meal_skewered_rat_burnt";

            // If you made a burnt final sprite, use it.
            // If not, fall back to the normal finished rat sprite.
            if (asset_get_index("spriteFoodFinalSkeweredRatBurnt") != -1)
            {
                finished_sprite = spriteFoodFinalSkeweredRatBurnt;
            }
            else
            {
                finished_sprite = spriteFoodFinalSkeweredRat;
            }

            finished_name = "Burnt Skewered Rat";

            finished_data = {
                recipe: "skewered_rat",
                container: "plate_regular",
                cook_state: "burnt",
                topping: "",
                quality: 0.35,
                sprite: finished_sprite
            };

            finish_lock_timer = 8;
        }
    }

    exit;
}

// ----------------------------------------------------
// Pick clean plate back up if no component has been added
// ----------------------------------------------------
if (has_plate && !has_component && _p.held_kind == "")
{
    _p.held_kind   = plate_kind;
    _p.held_sprite = plate_sprite;
    _p.held_image  = 0;
    _p.held_name   = plate_name;
    _p.held_data   = plate_data;
    _p.is_carrying = true;

    has_plate = false;
    plate_kind = "";
    plate_sprite = -1;
    plate_name = "";
    plate_data = undefined;

    exit;
}