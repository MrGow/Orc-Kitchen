/// oPlazaExit — Create

// ====================================================
// EXIT RECTANGLE
// ====================================================

// Rectangle dimensions.
// The object position is the rectangle centre.

exit_width = 70;
exit_height = 24;


// ====================================================
// EXIT STATE
// ====================================================

// The exit is disarmed when entering the room.
// Player must leave the rectangle completely
// before the doorway becomes active.

exit_armed = false;

// Prevent repeated room transitions.
exit_triggered = false;


// ====================================================
// DEBUG
// ====================================================

debug_draw = true;

depth = -10000;