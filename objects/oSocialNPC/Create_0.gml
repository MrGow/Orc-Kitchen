/// oSocialNPC — Create

// ====================================================
// INITIALIZE SHARED DATA
// ====================================================

scr_social_init();


// ====================================================
// NPC IDENTITY
// ====================================================

social_key = "";
npc_name = "UNKNOWN NPC";

max_rank = 5;


// ====================================================
// INTERACTION
// ====================================================

interact_range = 55;
player_near = false;


// ====================================================
// DIALOGUE STATE
// ====================================================

// idle  = no conversation
// intro = opening dialogue
// choice = spend evening confirmation
// event = relationship event dialogue

dialogue_mode = "idle";

dialogue_lines = [];
dialogue_index = 0;

choice_selected = 0;


// ====================================================
// CHARACTER CONTENT
// ====================================================

// Child objects replace these with their own text.

intro_lines = [
    "Hello there."
];

episodes = [];


// ====================================================
// CONVERSATION SAFETY
// ====================================================

event_committed = false;


// ====================================================
// PLACEHOLDER VISUALS
// ====================================================

npc_width = 30;
npc_height = 43;

npc_color = make_color_rgb(75, 125, 67);

depth = -y;