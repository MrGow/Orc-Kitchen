/// oPlayer — Step
/// Fixed collision mask, smooth movement,
/// directional animations, interactions and depth

// Do not tick movement, interaction, wobble or animation while paused.
if (global.paused) exit;

// ====================================================
// COLLISION HELPER
// ====================================================

function __orc_can_stand_at(_x, _y)
{
    // ------------------------------------------------
    // TILEMAP COLLISION
    // ------------------------------------------------

    if (
        !is_undefined(global.tm_solids)
        && global.tm_solids != -1
    )
    {
        var _l = _x - feet_half_w;
        var _r = _x + feet_half_w;
        var _t = _y - feet_half_h;
        var _b = _y + feet_half_h;

        if (
            tilemap_get_at_pixel(
                global.tm_solids, _l, _t
            ) != 0
        ) return false;

        if (
            tilemap_get_at_pixel(
                global.tm_solids, _r, _t
            ) != 0
        ) return false;

        if (
            tilemap_get_at_pixel(
                global.tm_solids, _l, _b
            ) != 0
        ) return false;

        if (
            tilemap_get_at_pixel(
                global.tm_solids, _r, _b
            ) != 0
        ) return false;

        if (
            tilemap_get_at_pixel(
                global.tm_solids, _x, _b
            ) != 0
        ) return false;
    }

    // ------------------------------------------------
    // STATION / FURNITURE COLLISION
    // ------------------------------------------------

    // Use the permanent spriteChefCollision mask
    // rather than the current animation sprite.

    var _old_x = x;
    var _old_y = y;

    x = _x;
    y = _y;

    var _blocked = false;

    if (object_exists(oSolidStation))
    {
        if (place_meeting(x, y, oSolidStation))
        {
            _blocked = true;
        }
    }

    x = _old_x;
    y = _old_y;

    return !_blocked;
}


// ====================================================
// KEYBOARD INPUT
// ====================================================

var _left =
    keyboard_check(vk_left)
    || keyboard_check(ord("A"));

var _right =
    keyboard_check(vk_right)
    || keyboard_check(ord("D"));

var _up =
    keyboard_check(vk_up)
    || keyboard_check(ord("W"));

var _down =
    keyboard_check(vk_down)
    || keyboard_check(ord("S"));


// ====================================================
// GAMEPAD INPUT
// ====================================================

var _gp = 0;

if (gamepad_is_connected(_gp))
{
    var _ax =
        gamepad_axis_value(_gp, gp_axislh);

    var _ay =
        gamepad_axis_value(_gp, gp_axislv);

    if (abs(_ax) > 0.25)
    {
        if (_ax < 0) _left = true;
        if (_ax > 0) _right = true;
    }

    if (abs(_ay) > 0.25)
    {
        if (_ay < 0) _up = true;
        if (_ay > 0) _down = true;
    }

    if (gamepad_button_check(_gp, gp_padl))
    {
        _left = true;
    }

    if (gamepad_button_check(_gp, gp_padr))
    {
        _right = true;
    }

    if (gamepad_button_check(_gp, gp_padu))
    {
        _up = true;
    }

    if (gamepad_button_check(_gp, gp_padd))
    {
        _down = true;
    }
}


// ====================================================
// MOVEMENT INPUT
// ====================================================

input_x =
    (_right ? 1 : 0)
    - (_left ? 1 : 0);

input_y =
    (_down ? 1 : 0)
    - (_up ? 1 : 0);

// Normalize diagonal movement.
var _len =
    point_distance(0, 0, input_x, input_y);

if (_len > 0)
{
    input_x /= _len;
    input_y /= _len;

    face_x = input_x;
    face_y = input_y;
}


// ====================================================
// INTERACTION KEY
// ====================================================

interact_key_pressed = keyboard_check_pressed(vk_space);
// E navigates tickets only inside MessHall, so retain E elsewhere.
if (room != MessHall) interact_key_pressed = interact_key_pressed || keyboard_check_pressed(ord("E"));

if (gamepad_is_connected(_gp))
{
    if (
        gamepad_button_check_pressed(
            _gp, gp_face1
        )
    )
    {
        interact_key_pressed = true;
    }
}


// ====================================================
// MOVEMENT
// ====================================================

// Record actual starting position.
var _start_x = x;
var _start_y = y;

if (
    !is_busy
    && !is_stunned
    && global.player_can_move
    && !instance_exists(oSupplyMenuController)
)
{
    var _spd = move_spd;

    if (is_carrying)
    {
        _spd *= carry_spd_mult;
    }

    var _mx = input_x * _spd;
    var _my = input_y * _spd;


    // ================================================
    // HORIZONTAL MOVEMENT
    // ================================================

    if (_mx != 0)
    {
        if (__orc_can_stand_at(x + _mx, y))
        {
            x += _mx;
        }
        else
        {
            // Approach obstacles in steps of up to
            // one pixel, preserving fractional motion.
            //
            // This avoids the old round(_mx)
            // overshoot when carrying or moving
            // diagonally.

            var _sx = sign(_mx);
            var _remain_x = abs(_mx);

            while (_remain_x > 0.0001)
            {
                var _step_x = min(1, _remain_x);

                if (
                    __orc_can_stand_at(
                        x + _sx * _step_x,
                        y
                    )
                )
                {
                    x += _sx * _step_x;
                    _remain_x -= _step_x;
                }
                else
                {
                    break;
                }
            }
        }
    }


    // ================================================
    // VERTICAL MOVEMENT
    // ================================================

    if (_my != 0)
    {
        if (__orc_can_stand_at(x, y + _my))
        {
            y += _my;
        }
        else
        {
            var _sy = sign(_my);
            var _remain_y = abs(_my);

            while (_remain_y > 0.0001)
            {
                var _step_y = min(1, _remain_y);

                if (
                    __orc_can_stand_at(
                        x,
                        y + _sy * _step_y
                    )
                )
                {
                    y += _sy * _step_y;
                    _remain_y -= _step_y;
                }
                else
                {
                    break;
                }
            }
        }
    }
}


// ====================================================
// DIRECTIONAL ANIMATION
// ====================================================

// Measure actual displacement, not just input.
var _actual_dx = x - _start_x;
var _actual_dy = y - _start_y;

var _actually_moving =
    abs(_actual_dx) > 0.001
    || abs(_actual_dy) > 0.001;

chef_was_moving = _actually_moving;

var _wanted_sprite = spriteChefIdle;
var _wanted_speed = chef_idle_anim_speed;
var _wanted_xscale = 1;


// ----------------------------------------------------
// MOVEMENT ANIMATION
// ----------------------------------------------------

if (_actually_moving)
{
    _wanted_speed = chef_run_anim_speed;

    if (abs(_actual_dx) > abs(_actual_dy) && abs(input_y) < 0.01)
    {
        // --------------------------------------------
        // HORIZONTAL
        // --------------------------------------------

        _wanted_sprite = spriteChefRunHorizontal;

        if (_actual_dx < 0)
        {
            // Source sprite faces right.
            // Flip to face left.
            chef_facing = 3;
            _wanted_xscale = -1;
        }
        else
        {
            chef_facing = 1;
            _wanted_xscale = 1;
        }
    }
    else
    {
        // --------------------------------------------
        // VERTICAL
        // --------------------------------------------

        _wanted_xscale = 1;

        if (_actual_dy < 0)
        {
            chef_facing = 2;
            _wanted_sprite = spriteChefRunUpwards;
        }
        else
        {
            chef_facing = 0;
            _wanted_sprite = spriteChefRunDownwards;
        }
    }
}


// ----------------------------------------------------
// CHANGE SPRITE ONLY WHEN NEEDED
// ----------------------------------------------------

if (sprite_index != _wanted_sprite)
{
    sprite_index = _wanted_sprite;
    image_index = 0;
}

image_speed = _wanted_speed;
image_xscale = _wanted_xscale;
image_yscale = 1;

// IMPORTANT:
// Do not change mask_index here.
// The mask set in Create remains active through
// every directional animation.


// ====================================================
// HELD ITEM WOBBLE
// ====================================================

if (is_carrying)
{
    held_wobble += 0.18;
}
else
{
    held_wobble = 0;
}


// ====================================================
// FIND NEAREST INTERACTABLE STATION / TABLE
// ====================================================

target_interact = noone;

var _best = noone;
var _best_d = interact_range;


// ----------------------------------------------------
// PLATE HOLDER
// ----------------------------------------------------

if (object_exists(oStationPlateHolder))
{
    var _inst =
        instance_nearest(
            x, y, oStationPlateHolder
        );

    if (_inst != noone)
    {
        var _d =
            point_distance(
                x, y, _inst.x, _inst.y
            );

        if (_d < _best_d)
        {
            _best = _inst;
            _best_d = _d;
        }
    }
}


// ----------------------------------------------------
// PREP COUNTER
// ----------------------------------------------------

if (object_exists(oStationPrepCounter))
{
    var _inst2 =
        instance_nearest(
            x, y, oStationPrepCounter
        );

    if (_inst2 != noone)
    {
        var _d2 =
            point_distance(
                x, y, _inst2.x, _inst2.y
            );

        if (_d2 < _best_d)
        {
            _best = _inst2;
            _best_d = _d2;
        }
    }
}


// ----------------------------------------------------
// PLATE CLEANER
// ----------------------------------------------------

if (object_exists(oStationPlateCleaner))
{
    var _inst3 =
        instance_nearest(
            x, y, oStationPlateCleaner
        );

    if (_inst3 != noone)
    {
        var _d3 =
            point_distance(
                x, y, _inst3.x, _inst3.y
            );

        if (_d3 < _best_d)
        {
            _best = _inst3;
            _best_d = _d3;
        }
    }
}


// ----------------------------------------------------
// MEAT RACK
// ----------------------------------------------------

if (object_exists(oStationMeatRack))
{
    var _inst4 =
        instance_nearest(
            x, y, oStationMeatRack
        );

    if (_inst4 != noone)
    {
        var _d4 =
            point_distance(
                x, y, _inst4.x, _inst4.y
            );

        if (_d4 < _best_d)
        {
            _best = _inst4;
            _best_d = _d4;
        }
    }
}


// ----------------------------------------------------
// GRILL
// ----------------------------------------------------

if (object_exists(oStationGrill))
{
    var _inst5 =
        instance_nearest(
            x, y, oStationGrill
        );

    if (_inst5 != noone)
    {
        var _d5 =
            point_distance(
                x, y, _inst5.x, _inst5.y
            );

        if (_d5 < _best_d)
        {
            _best = _inst5;
            _best_d = _d5;
        }
    }
}


// ----------------------------------------------------
// GOBBLE-TOAD
// ----------------------------------------------------

if (object_exists(oStationGobbleToad))
{
    var _inst7 =
        instance_nearest(
            x, y, oStationGobbleToad
        );

    if (_inst7 != noone)
    {
        var _d7 =
            point_distance(
                x, y, _inst7.x, _inst7.y
            );

            if (_d7 < _best_d)
        {
            _best = _inst7;
            _best_d = _d7;
        }
    }
}


// ====================================================
// TABLE INTERACTIONS
// ====================================================

// Tables use middle-bottom origins.
// Check seat and plate coordinates instead of
// measuring only to the table origin.

if (object_exists(oTableParent))
{
    var _table_count =
        instance_number(oTableParent);

    for (
        var _tn = 0;
        _tn < _table_count;
        _tn++
    )
    {
        var _tbl =
            instance_find(oTableParent, _tn);

        if (_tbl == noone)
        {
            continue;
        }

        if (
            !variable_instance_exists(
                _tbl, "seat_count"
            )
        )
        {
            continue;
        }

        if (
            !variable_instance_exists(
                _tbl, "seat_xoff"
            )
        )
        {
            continue;
        }

        if (
            !variable_instance_exists(
                _tbl, "plate_xoff"
            )
        )
        {
            continue;
        }

        for (
            var _si = 0;
            _si < _tbl.seat_count;
            _si++
        )
        {
            var _plate_x =
                _tbl.x
                + _tbl.plate_xoff[_si];

            var _plate_y =
                _tbl.y
                + _tbl.plate_yoff[_si];

            var _seat_x =
                _tbl.x
                + _tbl.seat_xoff[_si];

            var _seat_y =
                _tbl.y
                + _tbl.seat_yoff[_si];

            var _d_plate =
                point_distance(
                    x, y,
                    _plate_x, _plate_y
                );

            var _d_seat =
                point_distance(
                    x, y,
                    _seat_x, _seat_y
                );

            var _d_table =
                min(_d_plate, _d_seat);

            if (_d_table < _best_d)
            {
                _best = _tbl;
                _best_d = _d_table;
            }
        }
    }
}

target_interact = _best;


// ====================================================
// USE NEAREST STATION / TABLE
// ====================================================

if (
    interact_key_pressed
    && target_interact != noone
    && global.player_can_interact
    && !instance_exists(oSupplyMenuController)
)
{
    target_interact.interactor = id;

    with (target_interact)
    {
        event_user(0);
    }
}


// ====================================================
// DEPTH SORTING
// ====================================================

depth = -y;
