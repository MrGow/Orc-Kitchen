/// oSocialNPC — Step

// ====================================================
// PREPARATION
// ====================================================

player_near = false;

if (global.paused)
{
    exit;
}

if (instance_number(oPlayer) == 0)
{
    exit;
}

var _player = instance_nearest(x, y, oPlayer);

if (!instance_exists(_player))
{
    exit;
}


// ====================================================
// CURRENT RELATIONSHIP
// ====================================================

var _rank = variable_struct_get(
    global.social_ranks,
    social_key
);

var _has_event =
    _rank < max_rank
    && _rank < array_length(episodes);


// ====================================================
// INPUT
// ====================================================

var _interact =
    keyboard_check_pressed(ord("E"));

var _confirm =
    _interact
    || keyboard_check_pressed(vk_space)
    || keyboard_check_pressed(vk_enter);

var _up =
    keyboard_check_pressed(vk_up)
    || keyboard_check_pressed(ord("W"));

var _down =
    keyboard_check_pressed(vk_down)
    || keyboard_check_pressed(ord("S"));

var _cancel =
    keyboard_check_pressed(vk_escape);


// ====================================================
// IDLE / APPROACH
// ====================================================

if (dialogue_mode == "idle")
{
    var _distance = point_distance(
        x,
        y,
        _player.x,
        _player.y
    );

    player_near = _distance <= interact_range;

    if (!player_near)
    {
        exit;
    }

    if (!_interact)
    {
        exit;
    }

    if (!global.player_can_interact)
    {
        exit;
    }

    // Only one conversation at a time.
    if (global.social_active != noone)
    {
        if (instance_exists(global.social_active))
        {
            exit;
        }
    }

    global.social_active = id;

    global.player_can_move = false;
    global.player_can_interact = false;

    dialogue_mode = "intro";

    dialogue_lines = intro_lines;
    dialogue_index = 0;

    choice_selected = 0;
    event_committed = false;

    exit;
}


// ====================================================
// ENSURE WE OWN ACTIVE DIALOGUE
// ====================================================

if (global.social_active != id)
{
    exit;
}


// ====================================================
// CANCEL CONVERSATION
// ====================================================

if (_cancel && dialogue_mode != "event")
{
    dialogue_mode = "idle";
    dialogue_lines = [];

    global.social_active = noone;

    global.player_can_move = true;
    global.player_can_interact = true;

    exit;
}


// ====================================================
// INTRODUCTORY DIALOGUE
// ====================================================

if (dialogue_mode == "intro")
{
    if (!_confirm)
    {
        exit;
    }

    dialogue_index += 1;

    if (dialogue_index >= array_length(dialogue_lines))
    {
        if (_has_event
            && !global.evening_activity_used)
        {
            dialogue_mode = "choice";
            choice_selected = 0;
        }
        else
        {
            dialogue_mode = "idle";
            dialogue_lines = [];

            global.social_active = noone;

            global.player_can_move = true;
            global.player_can_interact = true;
        }
    }

    exit;
}


// ====================================================
// SPEND EVENING CONFIRMATION
// ====================================================

if (dialogue_mode == "choice")
{
    if (_up || _down)
    {
        choice_selected = 1 - choice_selected;
    }

    if (!_confirm)
    {
        exit;
    }

    // 1 = Not Now.
    if (choice_selected == 1)
    {
        dialogue_mode = "idle";
        dialogue_lines = [];

        global.social_active = noone;

        global.player_can_move = true;
        global.player_can_interact = true;

        exit;
    }

    // Recheck availability before starting.
    if (!_has_event
        || global.evening_activity_used)
    {
        exit;
    }

    // Begin the relationship event.
    var _episode = episodes[_rank];

    dialogue_mode = "event";
    dialogue_lines = _episode.lines;
    dialogue_index = 0;

    exit;
}


// ====================================================
// RELATIONSHIP EVENT
// ====================================================

if (dialogue_mode == "event")
{
    if (!_confirm)
    {
        exit;
    }

    dialogue_index += 1;

    if (dialogue_index < array_length(dialogue_lines))
    {
        exit;
    }

    // =================================================
    // COMPLETE EVENT — ONCE ONLY
    // =================================================

    if (event_committed)
    {
        exit;
    }

    event_committed = true;

    var _completed_episode = episodes[_rank];

    // Save the new relationship rank.
    variable_struct_set(
        global.social_ranks,
        social_key,
        min(max_rank, _rank + 1)
    );

    // Prototype HP reward.
    // Other NPCs can use different reward handling later.
    if (social_key == "gromm")
    {
        global.social_hp_bonus +=
            _completed_episode.hp_bonus;
    }

    // Use today's evening activity.
    global.evening_activity_used = true;

    global.social_active = noone;

    global.player_can_move = true;
    global.player_can_interact = true;

    if (global.ok_debug)
    {
        show_debug_message(
            "[Social] Completed "
            + npc_name
            + " rank "
            + string(_rank + 1)
        );

        show_debug_message(
            "[Social] Total relationship HP bonus: "
            + string(global.social_hp_bonus)
        );
    }

    // =================================================
    // RETURN HOME
    // =================================================

    global.game_state = "home";
    global.day_phase = "home";

    room_goto(Home);
}