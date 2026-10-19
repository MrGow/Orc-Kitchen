/// scr_social_init.gml

function scr_social_init()
{
    // ====================================================
    // RELATIONSHIP PROGRESS
    // ====================================================

    if (!variable_global_exists("social_ranks"))
    {
        global.social_ranks = {
            gromm: 0,
            nib: 0,
            lethriel: 0,
            skrik: 0,
            thespug: 0,
            wife: 0
        };
    }


    // ====================================================
    // EVENING ACTIVITY
    // ====================================================

    if (!variable_global_exists("evening_activity_used"))
    {
        global.evening_activity_used = false;
    }


    // ====================================================
    // ACTIVE CONVERSATION
    // ====================================================

    if (!variable_global_exists("social_active"))
    {
        global.social_active = noone;
    }

    if (global.social_active != noone)
    {
        if (!instance_exists(global.social_active))
        {
            global.social_active = noone;
        }
    }


    // ====================================================
    // FUTURE CHEF STAT BONUSES
    // ====================================================

    // This tracks HP earned from relationships.
    // It does not change the player's actual HP yet,
    // because we haven't implemented that system.

    if (!variable_global_exists("social_hp_bonus"))
    {
        global.social_hp_bonus = 0;
    }
}