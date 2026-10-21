
/// oInput — Step

// ====================================================
// FIND CONNECTED CONTROLLER
// ====================================================

// Keep the current controller if it is still connected.
if (
    input_gamepad != -1
    && !gamepad_is_connected(input_gamepad)
)
{
    input_gamepad = -1;
}

// Find a controller if none is currently assigned.
if (input_gamepad == -1)
{
    for (var i = 0; i < 12; i++)
    {
        if (gamepad_is_connected(i))
        {
            input_gamepad = i;
            break;
        }
    }
}

var pad_available = (input_gamepad != -1);

global.input_controller_connected = pad_available;
global.input_controller_id = input_gamepad;


// ====================================================
// KEYBOARD INPUT
// ====================================================

// Movement.
var kb_x =
    keyboard_check(ord("D"))
    - keyboard_check(ord("A"));

var kb_y =
    keyboard_check(ord("S"))
    - keyboard_check(ord("W"));


// Menu direction states.
var kb_up =
    keyboard_check(vk_up)
    || keyboard_check(ord("W"));

var kb_down =
    keyboard_check(vk_down)
    || keyboard_check(ord("S"));

var kb_left =
    keyboard_check(vk_left)
    || keyboard_check(ord("A"));

var kb_right =
    keyboard_check(vk_right)
    || keyboard_check(ord("D"));


// Action buttons.
var kb_confirm =
    keyboard_check_pressed(vk_space)
    || keyboard_check_pressed(vk_enter);

var kb_back =
    keyboard_check_pressed(vk_escape)
    || keyboard_check_pressed(vk_backspace);

var kb_interact =
    keyboard_check_pressed(ord("E"));

var kb_pause =
    keyboard_check_pressed(vk_escape);


// Held actions.
var kb_confirm_held =
    keyboard_check(vk_space)
    || keyboard_check(vk_enter);

var kb_interact_held =
    keyboard_check(ord("E"));


// ====================================================
// GAMEPAD INPUT
// ====================================================

var pad_x = 0;
var pad_y = 0;

var pad_up = false;
var pad_down = false;
var pad_left = false;
var pad_right = false;

var pad_confirm = false;
var pad_back = false;
var pad_interact = false;
var pad_pause = false;

var pad_confirm_held = false;
var pad_interact_held = false;

var pad_any_activity = false;


// ====================================================
// READ CONNECTED GAMEPAD
// ====================================================

if (pad_available)
{
    // ------------------------------------------------
    // LEFT ANALOGUE STICK
    // ------------------------------------------------

    var axis_x =
        gamepad_axis_value(
            input_gamepad,
            gp_axislh
        );

    var axis_y =
        gamepad_axis_value(
            input_gamepad,
            gp_axislv
        );

    // Radial deadzone and rescaling.
    var axis_length =
        point_distance(0, 0, axis_x, axis_y);

    if (axis_length > input_deadzone)
    {
        var scaled_length =
            clamp(
                (axis_length - input_deadzone)
                / (1 - input_deadzone),
                0,
                1
            );

        pad_x =
            (axis_x / axis_length) * scaled_length;

        pad_y =
            (axis_y / axis_length) * scaled_length;
    }


    // ------------------------------------------------
    // D-PAD
    // ------------------------------------------------

    var dpad_up =
        gamepad_button_check(
            input_gamepad,
            gp_padu
        );

    var dpad_down =
        gamepad_button_check(
            input_gamepad,
            gp_padd
        );

    var dpad_left =
        gamepad_button_check(
            input_gamepad,
            gp_padl
        );

    var dpad_right =
        gamepad_button_check(
            input_gamepad,
            gp_padr
        );


    // ------------------------------------------------
    // MENU NAVIGATION
    // ------------------------------------------------

    pad_up =
        dpad_up
        || axis_y < -input_menu_threshold;

    pad_down =
        dpad_down
        || axis_y > input_menu_threshold;

    pad_left =
        dpad_left
        || axis_x < -input_menu_threshold;

    pad_right =
        dpad_right
        || axis_x > input_menu_threshold;


    // ------------------------------------------------
    // CONTROLLER ACTIONS
    // ------------------------------------------------

    // Xbox A / Steam Input equivalent.
    pad_confirm =
        gamepad_button_check_pressed(
            input_gamepad,
            gp_face1
        );

    // Xbox B / Steam Input equivalent.
    pad_back =
        gamepad_button_check_pressed(
            input_gamepad,
            gp_face2
        );

    // A also interacts with world objects.
    pad_interact = pad_confirm;

    // Start pauses gameplay.
    pad_pause =
        gamepad_button_check_pressed(
            input_gamepad,
            gp_start
        );


    // ------------------------------------------------
    // HELD BUTTONS
    // ------------------------------------------------

    pad_confirm_held =
        gamepad_button_check(
            input_gamepad,
            gp_face1
        );

    pad_interact_held = pad_confirm_held;


    // ------------------------------------------------
    // DETECT MEANINGFUL CONTROLLER ACTIVITY
    // ------------------------------------------------

    // Require stronger analogue movement to avoid
    // switching prompts because of stick drift.

    pad_any_activity =
        (axis_length > 0.45)
        || dpad_up
        || dpad_down
        || dpad_left
        || dpad_right
        || pad_confirm_held
        || gamepad_button_check(
            input_gamepad,
            gp_face2
        )
        || gamepad_button_check(
            input_gamepad,
            gp_start
        );
}


// ====================================================
// DETECT MEANINGFUL KEYBOARD ACTIVITY
// ====================================================

var kb_any_activity =
    keyboard_check(ord("W"))
    || keyboard_check(ord("A"))
    || keyboard_check(ord("S"))
    || keyboard_check(ord("D"))
    || keyboard_check(vk_up)
    || keyboard_check(vk_down)
    || keyboard_check(vk_left)
    || keyboard_check(vk_right)
    || keyboard_check(vk_space)
    || keyboard_check(vk_enter)
    || keyboard_check(vk_escape)
    || keyboard_check(vk_backspace)
    || keyboard_check(ord("E"));


// ====================================================
// LAST USED DEVICE
// ====================================================

// Either device can take over automatically.
// Controller takes priority if both are active
// simultaneously.

if (kb_any_activity)
{
    global.input_device = "keyboard";
}

if (pad_any_activity)
{
    global.input_device = "controller";
}

global.input_using_controller =
    (global.input_device == "controller");


// ====================================================
// COMBINED MOVEMENT
// ====================================================

// Keyboard takes priority while movement keys
// are actively being held.

if (kb_x != 0 || kb_y != 0)
{
    global.input_move_x = kb_x;
    global.input_move_y = kb_y;
}
else
{
    global.input_move_x = pad_x;
    global.input_move_y = pad_y;
}

// Normalize diagonals.
var move_length =
    point_distance(
        0,
        0,
        global.input_move_x,
        global.input_move_y
    );

if (move_length > 1)
{
    global.input_move_x /= move_length;
    global.input_move_y /= move_length;
}


// ====================================================
// COMBINED MENU DIRECTIONS
// ====================================================

// Opposing directions cancel each other.

var menu_x =
    (kb_right || pad_right)
    - (kb_left || pad_left);

var menu_y =
    (kb_down || pad_down)
    - (kb_up || pad_up);


// ====================================================
// RESET NAVIGATION PRESSES
// ====================================================

global.input_up_pressed = false;
global.input_down_pressed = false;
global.input_left_pressed = false;
global.input_right_pressed = false;


// ====================================================
// VERTICAL MENU REPEAT
// ====================================================

if (menu_y == 0)
{
    input_vertical_last = 0;
    input_vertical_timer = 0;
}
else if (menu_y != input_vertical_last)
{
    // Immediate response to a new direction.
    if (menu_y < 0)
    {
        global.input_up_pressed = true;
    }
    else
    {
        global.input_down_pressed = true;
    }

    input_vertical_last = menu_y;
    input_vertical_timer = input_repeat_delay;
}
else
{
    // Direction is being held.
    input_vertical_timer -= 1;

    if (input_vertical_timer <= 0)
    {
        if (menu_y < 0)
        {
            global.input_up_pressed = true;
        }
        else
        {
            global.input_down_pressed = true;
        }

        input_vertical_timer =
            input_repeat_interval;
    }
}


// ====================================================
// HORIZONTAL MENU REPEAT
// ====================================================

if (menu_x == 0)
{
    input_horizontal_last = 0;
    input_horizontal_timer = 0;
}
else if (menu_x != input_horizontal_last)
{
    // Immediate response to a new direction.
    if (menu_x < 0)
    {
        global.input_left_pressed = true;
    }
    else
    {
        global.input_right_pressed = true;
    }

    input_horizontal_last = menu_x;
    input_horizontal_timer = input_repeat_delay;
}
else
{
    // Direction is being held.
    input_horizontal_timer -= 1;

    if (input_horizontal_timer <= 0)
    {
        if (menu_x < 0)
        {
            global.input_left_pressed = true;
        }
        else
        {
            global.input_right_pressed = true;
        }

        input_horizontal_timer =
            input_repeat_interval;
    }
}


// ====================================================
// COMBINED ACTION BUTTONS
// ====================================================

global.input_confirm_pressed =
    kb_confirm || pad_confirm;

global.input_back_pressed =
    kb_back || pad_back;

global.input_interact_pressed =
    kb_interact || pad_interact;

global.input_pause_pressed =
    kb_pause || pad_pause;


// ====================================================
// HELD ACTIONS
// ====================================================

global.input_confirm_held =
    kb_confirm_held || pad_confirm_held;

global.input_interact_held =
    kb_interact_held || pad_interact_held;
