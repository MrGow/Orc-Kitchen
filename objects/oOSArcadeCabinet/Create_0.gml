/// oOSArcadeCabinet — Create

// ====================================================
// OWNERSHIP
// ====================================================

// Preserve ownership between room changes.
// Do not reset this when Home reloads.

if (!variable_global_exists("arcade_owned"))
{
    global.arcade_owned = false;
}


// ====================================================
// ARCADE PROGRESS
// ====================================================

// These values will eventually be included
// in the main campaign save file.

if (!variable_global_exists("os_wave"))
{
    global.os_wave = 1;
}

if (!variable_global_exists("os_max_wave"))
{
    global.os_max_wave = 50;
}

if (!variable_global_exists("os_completed"))
{
    global.os_completed = false;
}


// ====================================================
// INTERACTION
// ====================================================

interact_range = 52;

player_near = false;

arcade_name = "ORC SURVIVORS";

// Initially match ownership.
visible = global.arcade_owned;

// The machine must not block the player.
// Collision can be added later if desired.
solid = false;

// Draw behind the player based on Y position.
depth = -y;