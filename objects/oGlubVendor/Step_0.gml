/// oGlubVendor — Step
// Like the carpenter, remains interactive while global.paused = true.
depth = -y;
if (feedback_timer > 0) feedback_timer--;

if (room != Market && room != CentralPlaza)
{
    if (shop_open)
    {
        shop_open = false;
        global.paused = false;
        global.player_can_move = true;
        global.player_can_interact = true;
    }
    exit;
}

var _confirm = keyboard_check_pressed(ord("E"))
    || keyboard_check_pressed(vk_enter)
    || keyboard_check_pressed(vk_space);
var _cancel = keyboard_check_pressed(vk_escape);

if (shop_open)
{
    global.paused = true;
    global.player_can_move = false;
    global.player_can_interact = false;

    if (_cancel)
    {
        shop_open = false;
        global.paused = false;
        global.player_can_move = true;
        global.player_can_interact = true;
        feedback_timer = 0;
        feedback_text = "";
        exit;
    }

    if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W")))
        selected = max(0, selected - 1);
    if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S")))
        selected = min(array_length(shop_items)-1, selected + 1);

    if (_confirm)
    {
        var _item = shop_items[selected];
        var _owned = false;
        for (var _i=0; _i<array_length(global.fishing_owned_cards); _i++)
        {
            if (global.fishing_owned_cards[_i] == _item.key) { _owned = true; break; }
        }
        if (_owned) feedback_text = "YE ALREADY KNOW DAT MOVE!";
        else if (global.gold < _item.price) feedback_text = "NOT ENOUGH GOLD!";
        else
        {
            global.gold -= _item.price;
            array_push(global.fishing_owned_cards, _item.key);
            feedback_text = "SOLD! YE LEARNED " + _item.name + "!";
            show_debug_message("[Glub] Sold " + _item.key + " for " + string(_item.price) + "g");
        }
        feedback_timer = round(room_speed * 2.5);
    }
    exit;
}

player_near = false;
if (global.paused || global.recipe_menu_open || !global.player_can_interact) exit;
if (!instance_exists(oPlayer)) exit;
var _p = instance_nearest(x, y, oPlayer);
if (_p == noone) exit;
player_near = (point_distance(x, y, _p.x, _p.y) <= interaction_range);
if (_confirm && player_near)
{
    shop_open = true;
    selected = 0;
    feedback_text = "";
    feedback_timer = 0;
    global.paused = true;
    global.player_can_move = false;
    global.player_can_interact = false;
}
