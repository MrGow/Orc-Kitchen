/// oMessHallExit — Create Event

// Automatic mess hall exit trigger.
// Place this at the bottom doorway / outside the tent.
// Give it a rectangle sprite/mask and scale it in the room editor.

exit_text = "";
exit_text_timer = 0;

// Prevent repeated room_goto calls.
triggered = false;

// If true, the trigger shows its rectangle in debug mode.
debug_draw = true;

// This object should be easy to see/debug, but it does not need depth sorting.
depth = -100;