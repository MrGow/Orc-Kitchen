/// oSleepTransition — Create
// A persistent, room-crossing cinematic controller.
// Do not place instances in any room: oHomeBed creates it.

persistent = true;
visible = true;
depth = -1000000;

if (instance_number(oSleepTransition) > 1)
{
    instance_destroy();
    exit;
}

// Tune these timings (seconds).
fade_out_seconds = 0.70;
sleep_hold_seconds = 1.80;
fade_in_seconds = 0.80;

fade_out_frames = max(1, round(room_speed * fade_out_seconds));
sleep_hold_frames = max(1, round(room_speed * sleep_hold_seconds));
fade_in_frames = max(1, round(room_speed * fade_in_seconds));

// fade_out -> sleep_hold -> wait_room -> fade_in -> finished
transition_state = "fade_out";
transition_frame = 0;
transition_alpha = 0;
day_advanced = false;

global.sleep_transition_active = true;
global.player_can_move = false;
global.player_can_interact = false;

// Optional audio hook. Create a Sound asset named SleepNightJingle
// when ready; the transition works without it.
var _sound = asset_get_index("SleepNightJingle");
if (_sound != -1 && asset_get_type(_sound) == asset_sound)
{
    audio_play_sound(_sound, 10, false);
}
