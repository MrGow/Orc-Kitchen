/// oSleepTransition — Clean Up
// Safety reset when controller is destroyed normally.
// Do not leave the gameplay frozen in ordinary operation.

global.sleep_transition_active = false;
