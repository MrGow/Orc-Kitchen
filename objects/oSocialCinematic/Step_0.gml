/// oSocialCinematic — Step

// ====================================================
// DETECT ACTIVE RELATIONSHIP EVENT
// ====================================================

var _in_event = false;

if (variable_global_exists("social_active"))
{
    var _npc = global.social_active;

    if (_npc != noone)
    {
        if (instance_exists(_npc))
        {
            _in_event =
                (_npc.dialogue_mode == "event");
        }
    }
}


// ====================================================
// SET TARGET
// ====================================================

bar_target = _in_event ? 1 : 0;


// ====================================================
// ANIMATE LETTERBOX
// ====================================================

var _duration_frames = max(
    1,
    room_speed * bar_animation_duration
);

var _step = 1 / _duration_frames;

if (bar_progress < bar_target)
{
    bar_progress = min(
        bar_target,
        bar_progress + _step
    );
}
else if (bar_progress > bar_target)
{
    bar_progress = max(
        bar_target,
        bar_progress - _step
    );
}


// ====================================================
// PUBLISH SHARED STATE
// ====================================================

global.social_cine_active =
    (bar_progress > 0);

global.social_cine_bar_height =
    bar_target_height * bar_progress;