/// oMessHallExit — Create Event

// ====================================================
// EXIT TEXT
// ====================================================

exit_text = "";
exit_text_timer = 0;


// ====================================================
// EXIT STATE
// ====================================================

// Prevent repeated room_goto calls.
triggered = false;

// Starts disarmed.
//
// The player must completely leave the doorway
// before this exit can activate.
exit_armed = false;


// ====================================================
// DEBUG
// ====================================================

debug_draw = true;

// Keep existing depth.
depth = -100;