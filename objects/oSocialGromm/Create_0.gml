/// oSocialGromm — Create

// ====================================================
// INHERIT SHARED SOCIAL SYSTEM
// ====================================================

event_inherited();


// ====================================================
// CHARACTER IDENTITY
// ====================================================

social_key = "gromm";

npc_name = "GROMM";

max_rank = 5;


// ====================================================
// APPEARANCE
// ====================================================

npc_width = 35;
npc_height = 48;

npc_color = make_color_rgb(
    75,
    115,
    54
);

interact_range = 60;


// ====================================================
// INTRODUCTORY DIALOGUE
// ====================================================

intro_lines = [
    "OI, CHEF! COME 'ERE A MINUTE!",
    "I'M GROMM! STRONGEST ORC IN DIS WHOLE CAMP!",
    "WANNA FIND OUT HOW STRONG I REALLY AM?"
];


// ====================================================
// RELATIONSHIP EVENTS
// ====================================================

// Each entry is one relationship chapter.
//
// Later characters can have their own array of
// episodes using the same structure.
//
// Rank 0 plays episodes[0].
// Rank 1 plays episodes[1], and so on.
//
// For now, only Gromm's first chapter is available.

episodes = [

    // ================================================
    // RANK 1 — THE ARM-WRESTLING CHALLENGE
    // ================================================

    {
        title: "Arm-Wrestling Challenge",

        reward_text: "+5 Maximum HP",

        hp_bonus: 5,

        lines: [
            "GROMM: RIGHT! LET'S SEE HOW STRONG YE ARE!",

            "GROMM SLAMS HIS ELBOW ONTO A WOODEN TABLE.",

            "GROMM: FIRST ONE TO PIN DA OTHER WINS!",

            "THE CHEF GRABS GROMM'S HAND.",

            "GROMM: THREE... TWO... WAAAAAGH!",

            "THE TABLE IMMEDIATELY EXPLODES INTO SPLINTERS.",

            "BOTH ORCS FALL FLAT ON THEIR BACKS.",

            "GROMM: HAHAHA! GOOD MATCH, CHEF!",

            "GROMM: TOMORROW WE LIFT SOMETHIN' BIGGER!",

            "RELATIONSHIP UP! GROMM — RANK 1.",
            "MAXIMUM HP BONUS: +5."
        ]
    }
];