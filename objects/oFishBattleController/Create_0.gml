/// oFishBattleController — Create
// One instance placed in FishBattle. No sprite.
if (instance_number(oFishBattleController) > 1) { instance_destroy(); exit; }

// Persistent, save-ready progression (disk save comes later).
if (!variable_global_exists("fishing_level")) global.fishing_level = 1;
if (!variable_global_exists("fishing_xp")) global.fishing_xp = 0;
if (!variable_global_exists("fishing_wins")) global.fishing_wins = 0;
if (!variable_global_exists("evening_activity_used")) global.evening_activity_used = false;

// Presentation / state machine.
state = "shore";       // shore, choose, chef_action, fish_action, result
shore_choice = 0;     // 0 Go Fish, 1 Leave
selected_card = 0; // Selection is an index into hand_cards.
phase_timer = 0;
result_timer = 0;
message = "THE RIVER SMELLS OF VIOLENCE.";
result_text = "";
win = false;

// The player selects moves; these are NOT draw/discard cards.
cards = [
    { name: "PUNCH",         subtitle: "6-9 DMG",      charges: -1, max_charges: -1, color: make_color_rgb(111,83,53) },
    { name: "BIG PUNCH",     subtitle: "12-17 DMG / 75%", charges: 3, max_charges: 3, color: make_color_rgb(136,76,48) },
    { name: "DEFEND",        subtitle: "HALVE NEXT HIT",charges: -1, max_charges: -1, color: make_color_rgb(62,88,111) }
];

// Learned / purchased fishing cards persist through room changes.
// Disk persistence is handled later by the shared bedtime save system.
if (!variable_global_exists("fishing_owned_cards"))
    global.fishing_owned_cards = ["punch", "big_punch", "defend"];

// Append purchased moves to the existing three starter cards.
// No draw pile: these are always available at the start of each fight.
for (var _c=0; _c<array_length(global.fishing_owned_cards); _c++)
{
    var _key = global.fishing_owned_cards[_c];
    switch (_key)
    {
        case "lick_wounds":
            array_push(cards, {name:"LICK YER WOUNDS", subtitle:"HEAL 12 HP", charges:2, max_charges:2, color:make_color_rgb(55,115,79)});
            break;
        case "iron_gut":
            array_push(cards, {name:"IRON GUT", subtitle:"BLOCK NEXT HIT", charges:2, max_charges:2, color:make_color_rgb(66,102,130)});
            break;
        case "electric_slap":
            array_push(cards, {name:"ELECTRIC SLAP", subtitle:"12-16 DMG / STUN", charges:2, max_charges:2, color:make_color_rgb(109,72,159)});
            break;
        case "fish_execution":
            array_push(cards, {name:"FISH EXECUTION", subtitle:"FINISH WEAK FISH", charges:1, max_charges:1, color:make_color_rgb(166,115,42)});
            break;
    }
}
chef_iron_guard = false;
fish_stunned = false;

// Visible hand indexes the master cards array. Spent cards leave the hand,
// but stay unlocked in cards and refresh next battle.
hand_cards = [0, 1, 2];
played_card = undefined;
card_play_timer = 0;
card_play_duration = max(1, round(room_speed * 0.55));
hand_bob_timer = 0;

chef_max_hp = 42 + (global.fishing_level - 1) * 3;
chef_hp = chef_max_hp;
chef_defending = false;
fish_name = "";
fish_tier = "common";
fish_max_hp = 1;
fish_hp = 1;
fish_damage = 1;
fish_gold = 0;
fish_xp = 0;

// Simple camera-independent UI animation.
last_card = -1;
impact_timer = 0;
shake_timer = 0;
shake_strength = 3;

// Controller draws full screen in Draw GUI End above the normal HUD.
depth = -1000;
