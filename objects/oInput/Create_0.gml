
/// oInput — Create

// ====================================================
// PERSISTENCE
// ====================================================

// Only one input controller should exist.
persistent = true;

if (instance_number(oInput) > 1)
{
    instance_destroy();
    exit;
}


// ====================================================
// CONTROLLER SETTINGS
// ====================================================

// GameMaker gamepad slot.
// -1 means no controller connected.
input_gamepad = -1;

// Analogue stick deadzone.
input_deadzone = 0.25;

// Stronger threshold for menu navigation.
input_menu_threshold = 0.55;

// How long to wait before repeating a held menu direction.
input_repeat_delay = 18;

// Frames between repeated menu movements.
input_repeat_interval = 6;

// Internal repeat tracking.
input_vertical_last = 0;
input_horizontal_last = 0;

input_vertical_timer = 0;
input_horizontal_timer = 0;


// ====================================================
// LAST USED INPUT DEVICE
// ====================================================

// Possible values:
// "keyboard"
// "controller"

global.input_device = "keyboard";

// Used later for dynamic button prompts.
global.input_using_controller = false;


// ====================================================
// MOVEMENT
// ====================================================

// Values from -1 to 1.
global.input_move_x = 0;
global.input_move_y = 0;


// ====================================================
// MENU NAVIGATION
// ====================================================

global.input_up_pressed = false;
global.input_down_pressed = false;
global.input_left_pressed = false;
global.input_right_pressed = false;


// ====================================================
// MENU ACTIONS
// ====================================================

global.input_confirm_pressed = false;
global.input_back_pressed = false;


// ====================================================
// GAMEPLAY ACTIONS
// ====================================================

global.input_interact_pressed = false;
global.input_pause_pressed = false;


// ====================================================
// ADDITIONAL STATES
// ====================================================

// These are useful for future interfaces.
global.input_confirm_held = false;
global.input_interact_held = false;

global.input_controller_connected = false;
global.input_controller_id = -1;
