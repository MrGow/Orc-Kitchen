/// oPlayer — Step Event
// Top-down movement + basic collision + interaction scaffold

// ----------------------------------------------------
// Local helper: checks whether the player's feet area is clear
// ----------------------------------------------------
function __orc_can_stand_at(_x, _y)
{
    // If no tilemap is bound, allow movement.
    if (is_undefined(global.tm_solids) || global.tm_solids == -1)
    {
        return true;
    }

    // Check several points around the player's feet.
    var _l = _x - feet_half_w;
    var _r = _x + feet_half_w;
    var _t = _y - feet_half_h;
    var _b = _y + feet_half_h;

    if (tilemap_get_at_pixel(global.tm_solids, _l, _t) != 0) return false;
    if (tilemap_get_at_pixel(global.tm_solids, _r, _t) != 0) return false;
    if (tilemap_get_at_pixel(global.tm_solids, _l, _b) != 0) return false;
    if (tilemap_get_at_pixel(global.tm_solids, _r, _b) != 0) return false;
    if (tilemap_get_at_pixel(global.tm_solids, _x, _b) != 0) return false;

    return true;
}

// ----------------------------------------------------
// Input
// ----------------------------------------------------
var _left  = keyboard_check(vk_left)  || keyboard_check(ord("A"));
var _right = keyboard_check(vk_right) || keyboard_check(ord("D"));
var _up    = keyboard_check(vk_up)    || keyboard_check(ord("W"));
var _down  = keyboard_check(vk_down)  || keyboard_check(ord("S"));

// Gamepad left stick / d-pad support
var _gp = 0;
if (gamepad_is_connected(_gp))
{
    var _ax = gamepad_axis_value(_gp, gp_axislh);
    var _ay = gamepad_axis_value(_gp, gp_axislv);

    if (abs(_ax) > 0.25)
    {
        if (_ax < 0) _left  = true;
        if (_ax > 0) _right = true;
    }

    if (abs(_ay) > 0.25)
    {
        if (_ay < 0) _up   = true;
        if (_ay > 0) _down = true;
    }

    if (gamepad_button_check(_gp, gp_padl)) _left  = true;
    if (gamepad_button_check(_gp, gp_padr)) _right = true;
    if (gamepad_button_check(_gp, gp_padu)) _up    = true;
    if (gamepad_button_check(_gp, gp_padd)) _down  = true;
}

input_x = (_right ? 1 : 0) - (_left ? 1 : 0);
input_y = (_down  ? 1 : 0) - (_up   ? 1 : 0);

// Normalize diagonal movement
var _len = point_distance(0, 0, input_x, input_y);
if (_len > 0)
{
    input_x /= _len;
    input_y /= _len;

    face_x = input_x;
    face_y = input_y;
}

// ----------------------------------------------------
// Interaction key
// ----------------------------------------------------
interact_key_pressed =
    keyboard_check_pressed(ord("E")) ||
    keyboard_check_pressed(vk_space);

if (gamepad_is_connected(_gp))
{
    if (gamepad_button_check_pressed(_gp, gp_face1))
    {
        interact_key_pressed = true;
    }
}

// ----------------------------------------------------
// Movement
// ----------------------------------------------------
if (!is_busy && !is_stunned)
{
    var _spd = move_spd;

    if (is_carrying)
    {
        _spd *= carry_spd_mult;
    }

    var _mx = input_x * _spd;
    var _my = input_y * _spd;

    // Move X then Y for simple sliding along walls.
    if (_mx != 0)
    {
        if (__orc_can_stand_at(x + _mx, y))
        {
            x += _mx;
        }
        else
        {
            // Pixel nudge for nicer collision feel
            var _sx = sign(_mx);
            repeat (abs(round(_mx)))
            {
                if (__orc_can_stand_at(x + _sx, y)) x += _sx;
                else break;
            }
        }
    }

    if (_my != 0)
    {
        if (__orc_can_stand_at(x, y + _my))
        {
            y += _my;
        }
        else
        {
            var _sy = sign(_my);
            repeat (abs(round(_my)))
            {
                if (__orc_can_stand_at(x, y + _sy)) y += _sy;
                else break;
            }
        }
    }
}

// ----------------------------------------------------
// Animation
// ----------------------------------------------------
// You only have idle for now, so keep it simple.
// Later you can switch between idle/walk/carry idle/carry walk here.
if (input_x != 0 || input_y != 0)
{
    image_speed = 0.18;
}
else
{
    image_speed = 0.10;
}

// ----------------------------------------------------
// Held item wobble
// ----------------------------------------------------
if (is_carrying)
{
    held_wobble += 0.18;
}
else
{
    held_wobble = 0;
}

// ----------------------------------------------------
// Interaction scaffold
// ----------------------------------------------------
// Later, stations can register themselves as interactables.
// For now this just provides the button hook.
if (interact_key_pressed)
{
    // Placeholder:
    // This is where you will later call:
    // scr_player_interact_nearest(id);
    //
    // Or stations can check distance to player themselves.
}

// ----------------------------------------------------
// Depth sorting
// ----------------------------------------------------
depth = -y;