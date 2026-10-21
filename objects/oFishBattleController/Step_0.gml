/// oFishBattleController — Step
// One battle per evening in this scaffold.
if (room != FishBattle) exit;

var _left = keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"));
var _right = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"));
var _up = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
var _down = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
var _confirm = keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);
var _cancel = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(vk_backspace);

if (impact_timer > 0) impact_timer -= 1;
if (shake_timer > 0) shake_timer -= 1;
hand_bob_timer += 1;
if (card_play_timer > 0) card_play_timer -= 1;

// ----------------------------------------------------
// RIVERBANK / BACK-OUT SCREEN
// ----------------------------------------------------
if (state == "shore")
{
    if (_up || _left) shore_choice = max(0, shore_choice - 1);
    if (_down || _right) shore_choice = min(1, shore_choice + 1);
    if (_cancel) shore_choice = 1;

    if (_confirm || _cancel)
    {
        if (shore_choice == 1)
        {
            // Browsing/turning around at the river is free.
            global.game_state = "camp_map";
            global.day_phase = "camp_map";
            room_goto(WarCampMap);
            exit;
        }
        if (global.evening_activity_used)
        {
            message = "YE ALREADY SPENT YER EVENIN'!";
            exit;
        }

        // The evening is committed on starting the fight.
        global.evening_activity_used = true;
        chef_max_hp = 42 + (global.fishing_level - 1) * 3;
        chef_hp = chef_max_hp;
        chef_defending = false;
        hand_cards = [];
        for (var _i = 0; _i < array_length(cards); _i++)
        {
            cards[_i].charges = cards[_i].max_charges;
            array_push(hand_cards, _i);
        }
        played_card = undefined;
        card_play_timer = 0;

        // Provisional rarity curve: higher fishing levels attract better fish.
        // Four anchor tiers, interpolated simply from level 1 to 20.
        var _t = clamp((global.fishing_level - 1) / 19, 0, 1);
        var _common = lerp(65, 10, _t);
        var _uncommon = lerp(23, 35, _t);
        var _rare = lerp(10, 40, _t);
        var _roll = random(100);
        if (_roll < _common)
        {
            fish_tier = "common";
            fish_name = "MUD TROUT";
            fish_max_hp = 20; fish_damage = 4; fish_gold = irandom_range(4, 7); fish_xp = 5;
        }
        else if (_roll < _common + _uncommon)
        {
            fish_tier = "uncommon";
            fish_name = "ANGRY CARP";
            fish_max_hp = 35; fish_damage = 7; fish_gold = irandom_range(8, 14); fish_xp = 10;
        }
        else if (_roll < _common + _uncommon + _rare)
        {
            fish_tier = "rare";
            fish_name = "BLOATED CATFISH";
            fish_max_hp = 64; fish_damage = 11; fish_gold = irandom_range(15, 30); fish_xp = 18;
        }
        else
        {
            fish_tier = "legendary";
            fish_name = "GREAT SWORDFISH";
            fish_max_hp = 125; fish_damage = 19; fish_gold = irandom_range(50, 80); fish_xp = 35;
        }
        fish_hp = fish_max_hp;
        selected_card = 0;
        message = "A WILD " + fish_name + " WANTS A FIGHT!";
        state = "choose";
    }
    exit;
}

// ----------------------------------------------------
// CHOOSE A MOVE CARD
// ----------------------------------------------------
if (state == "choose")
{
    var _hand_count = array_length(hand_cards);
    if (_hand_count <= 0) exit;

    if (_left) selected_card = (selected_card + _hand_count - 1) mod _hand_count;
    if (_right) selected_card = (selected_card + 1) mod _hand_count;

    if (_cancel)
    {
        // Retreat counts as the evening's activity once the fight began.
        win = false;
        result_text = "YE RAN AWAY FROM A FISH!";
        result_timer = round(room_speed * 2.8);
        state = "result";
        exit;
    }

    if (_confirm)
    {
        // selected_card is the HAND position, not the master card ID.
        var _card_id = hand_cards[selected_card];
        var _card = cards[_card_id];

        // Snapshot for the centre-screen card animation, even if exhausted.
        played_card = {
            name: _card.name,
            subtitle: _card.subtitle,
            color: _card.color,
            charges: _card.charges,
            max_charges: _card.max_charges
        };
        card_play_timer = card_play_duration;
        last_card = _card_id;

        if (_card.charges > 0)
        {
            cards[_card_id].charges -= 1;

            // When a limited-use card reaches zero, it LEAVES the visible hand.
            // The underlying learned card remains owned for the next fish fight.
            if (cards[_card_id].charges == 0)
            {
                array_delete(hand_cards, selected_card, 1);
                if (array_length(hand_cards) > 0)
                    selected_card = min(selected_card, array_length(hand_cards) - 1);
                else
                    selected_card = 0;
            }
        }

        var _dmg = 0;
        if (_card_id == 0)
        {
            _dmg = irandom_range(6, 9) + (global.fishing_level - 1);
            message = "YE PUNCHED DA FISH FOR " + string(_dmg) + "!";
        }
        else if (_card_id == 1)
        {
            if (random(1) < 0.75)
            {
                _dmg = irandom_range(12, 17) + (global.fishing_level - 1) * 2;
                message = "BIG PUNCH! " + string(_dmg) + " DAMAGE!";
            }
            else message = "BIG PUNCH MISSED! EMBARRASSIN'!";
        }
        else if (_card.name == "DEFEND")
        {
            chef_defending = true;
            message = "YE BRACED FER DA FISH'S ATTACK!";
        }
        else if (_card.name == "LICK YER WOUNDS")
        {
            var _heal = min(12, chef_max_hp-chef_hp);
            chef_hp += _heal;
            message = "YE LICKED YER WOUNDS! +" + string(_heal) + " HP!";
        }
        else if (_card.name == "IRON GUT")
        {
            chef_iron_guard = true;
            message = "IRON GUT! NEXT FISH HIT GETS BLOCKED!";
        }
        else if (_card.name == "ELECTRIC SLAP")
        {
            _dmg = irandom_range(12, 16) + (global.fishing_level-1);
            fish_stunned = (random(1) < 0.30);
            message = "ELECTRIC SLAP! " + string(_dmg) + " DAMAGE!";
            if (fish_stunned) message += " DA FISH IS STUNNED!";
        }
        else if (_card.name == "FISH EXECUTION")
        {
            if (fish_hp <= fish_max_hp*0.30)
                _dmg = 42 + (global.fishing_level-1)*2;
            else
                _dmg = 8;
            message = "FISH EXECUTION! " + string(_dmg) + " DAMAGE!";
        }

        fish_hp = max(0, fish_hp - _dmg);
        impact_timer = round(room_speed * 0.20);
        shake_timer = round(room_speed * 0.16);
        // Hold for the card flourish, then proceed to fish retaliation.
        phase_timer = max(card_play_duration, round(room_speed * 0.7));
        state = "chef_action";
    }
    exit;
}

// ----------------------------------------------------
// SHOW CHEF CARD IN CENTRE, THEN FISH RETALIATES
// ----------------------------------------------------
if (state == "chef_action")
{
    phase_timer -= 1;
    if (phase_timer <= 0)
    {
        if (fish_hp <= 0)
        {
            win = true;
            global.gold += fish_gold;
            global.fishing_wins += 1;
            global.fishing_xp += fish_xp;
            // Tiny, save-ready fishing-level progression.
            while (global.fishing_level < 20 && global.fishing_xp >= global.fishing_level * 12)
            {
                global.fishing_xp -= global.fishing_level * 12;
                global.fishing_level += 1;
            }
            result_text = "FISH SMASHED! SOLD FER " + string(fish_gold) + " GOLD!";
            result_timer = round(room_speed * 3.2);
            state = "result";
        }
        else if (fish_stunned)
        {
            fish_stunned = false;
            chef_defending = false;
            message = fish_name + " CAN'T MOVE! STUNNED!";
            state = "choose";
        }
        else
        {
            var _taken = fish_damage;
            if (chef_iron_guard)
            {
                _taken = 0;
                chef_iron_guard = false;
            }
            else if (chef_defending) _taken = ceil(_taken * 0.5);
            chef_defending = false;
            chef_hp = max(0, chef_hp - _taken);
            message = fish_name + " USED FLOP! " + string(_taken) + " DAMAGE!";
            impact_timer = round(room_speed * 0.20);
            shake_timer = round(room_speed * 0.16);
            phase_timer = round(room_speed * 0.75);
            state = "fish_action";
        }
    }
    exit;
}

// ----------------------------------------------------
// FISH ATTACK ANIMATION / DEFEAT
// ----------------------------------------------------
if (state == "fish_action")
{
    phase_timer -= 1;
    if (phase_timer <= 0)
    {
        if (chef_hp <= 0)
        {
            win = false;
            result_text = "DA FISH BEAT YE UP! NO GOLD!";
            result_timer = round(room_speed * 3.2);
            state = "result";
        }
        else state = "choose";
    }
    exit;
}

// ----------------------------------------------------
// RESULT -> HOME (evening consumed)
// ----------------------------------------------------
if (state == "result")
{
    result_timer -= 1;
    if (result_timer <= 0)
    {
        global.evening_activity_used = true;
        global.game_state = "home";
        global.day_phase = "home";
        global.paused = false;
        global.recipe_menu_open = false;
        room_goto(Home);
    }
}
