/// oVendorCarpenter — Step Event

depth = -y;


// ====================================================
// FEEDBACK TIMER
// ====================================================

if (feedback_timer > 0)
{
    feedback_timer -= 1;
}


// ====================================================
// ROOM SAFETY
// ====================================================

if (room != Market)
{
    if (shop_open)
    {
        shop_open = false;
        global.paused = false;
    }

    exit;
}


// ====================================================
// INPUT
// ====================================================

var _confirm =
    keyboard_check_pressed(ord("E"))
    || keyboard_check_pressed(vk_enter)
    || keyboard_check_pressed(vk_space);

var _cancel =
    keyboard_check_pressed(vk_escape);


// ====================================================
// SHOP OPEN
// ====================================================

if (shop_open)
{
    global.paused = true;

    global.player_can_move = false;
    global.player_can_interact = false;


    // ------------------------------------------------
    // CLOSE SHOP
    // ------------------------------------------------

    if (_cancel)
    {
        shop_open = false;

        global.paused = false;

        global.player_can_move = true;
        global.player_can_interact = true;

        feedback_text = "";
        feedback_timer = 0;

        exit;
    }


    // ------------------------------------------------
    // NAVIGATION
    // ------------------------------------------------

    var _up =
        keyboard_check_pressed(vk_up)
        || keyboard_check_pressed(ord("W"));

    var _down =
        keyboard_check_pressed(vk_down)
        || keyboard_check_pressed(ord("S"));

    if (_up)
    {
        selected = max(0, selected - 1);
    }

    if (_down)
    {
        selected = min(
            array_length(shop_items) - 1,
            selected + 1
        );
    }


    // ------------------------------------------------
    // PURCHASE
    // ------------------------------------------------

    if (_confirm)
    {
        var _item = shop_items[selected];

        feedback_text = "";


        // ============================================
        // TABLE PURCHASE
        // ============================================

        if (_item.kind == "table")
        {
            var _id = _item.table_id;

            if (!variable_global_exists("tables_owned")
                || !variable_global_exists("table_prices"))
            {
                feedback_text =
                    "TABLE OWNERSHIP NOT INITIALISED!";
            }
            else if (
                _id >= array_length(global.tables_owned)
                || _id >= array_length(global.table_prices)
            )
            {
                feedback_text =
                    "INVALID TABLE ID!";
            }
            else if (global.tables_owned[_id])
            {
                feedback_text =
                    "ALREADY OWNED!";
            }
            else
            {
                var _cost =
                    global.table_prices[_id];

                if (global.gold < _cost)
                {
                    feedback_text =
                        "NOT ENOUGH GOLD!";
                }
                else
                {
                    global.gold -= _cost;

                    global.tables_owned[_id] = true;

                    feedback_text =
                        "SOLD! DELIVERED TO THE MESS HALL!";

                    show_debug_message(
                        "[Carpenter] Bought table ID "
                        + string(_id)
                        + " for "
                        + string(_cost)
                        + " gold."
                    );
                }
            }
        }


        // ============================================
        // ARCADE CABINET PURCHASE
        // ============================================

        else if (_item.kind == "arcade")
        {
            if (!variable_global_exists("arcade_owned"))
            {
                global.arcade_owned = false;
            }

            if (global.arcade_owned)
            {
                feedback_text =
                    "ALREADY OWNED!";
            }
            else if (global.gold < arcade_price)
            {
                feedback_text =
                    "NOT ENOUGH GOLD!";
            }
            else
            {
                global.gold -= arcade_price;

                global.arcade_owned = true;

                feedback_text =
                    "SOLD! ARCADE DELIVERED HOME!";

                show_debug_message(
                    "[Carpenter] Orc Survivors arcade "
                    + "purchased for "
                    + string(arcade_price)
                    + " gold."
                );
            }
        }


        // ============================================
        // UNKNOWN ITEM
        // ============================================

        else
        {
            feedback_text =
                "INVALID SHOP ITEM!";
        }


        // ------------------------------------------------
        // FEEDBACK DURATION
        // ------------------------------------------------

        feedback_timer = room_speed * 2;
    }

    exit;
}


// ====================================================
// SHOP CLOSED
// ====================================================

if (global.paused || global.recipe_menu_open)
{
    exit;
}

if (!_confirm)
{
    exit;
}

if (!instance_exists(oPlayer))
{
    exit;
}


// ====================================================
// FIND NEAREST PLAYER
// ====================================================

var _p = instance_nearest(
    x,
    y,
    oPlayer
);

if (_p == noone)
{
    exit;
}


// ====================================================
// PLAYER DISTANCE FROM VENDOR BOUNDS
// ====================================================

var _near_x = clamp(
    _p.x,
    bbox_left,
    bbox_right
);

var _near_y = clamp(
    _p.y,
    bbox_top,
    bbox_bottom
);

var _distance = point_distance(
    _p.x,
    _p.y,
    _near_x,
    _near_y
);


// ====================================================
// OPEN SHOP
// ====================================================

if (_distance <= interaction_range)
{
    shop_open = true;

    selected = 0;

    feedback_text = "";
    feedback_timer = 0;

    global.paused = true;

    global.player_can_move = false;
    global.player_can_interact = false;
}