/// oFishBattleController — Draw GUI End
// Full-screen prototype presentation. Draw GUI End masks the main HUD.
if (room != FishBattle) exit;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _sx = _gw / 640;
var _sy = _gh / 360;

var _font = asset_get_index("PixelifyRegular12");
var _title = asset_get_index("PixelifyBold14");
if (_title == -1) _title = _font;
draw_set_font(_font);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);

// Entire scene in the established 640x360 GUI coordinate system.
draw_set_color(make_color_rgb(26, 40, 43));
draw_rectangle(0, 0, _gw, _gh, false);

if (state == "shore")
{
    // Future: replace with illustrated chef on riverbank.
    draw_set_color(make_color_rgb(67, 88, 65));
    draw_rectangle(0, 0, _gw, _gh * 0.60, false);
    draw_set_color(make_color_rgb(47, 83, 103));
    draw_rectangle(0, _gh * 0.60, _gw, _gh, false);
    draw_set_color(make_color_rgb(82, 155, 178));
    for (var _w = 0; _w < 6; _w++)
    {
        var _wave_y = _gh * 0.65 + _w * 18 * _sy;
        draw_line(0, _wave_y, _gw, _wave_y);
    }

    // Blocky placeholder chef on the riverbank.
    draw_set_color(make_color_rgb(83, 142, 61));
    draw_rectangle(135 * _sx, 130 * _sy, 175 * _sx, 226 * _sy, false);
    draw_set_color(make_color_rgb(147, 185, 86));
    draw_rectangle(140 * _sx, 110 * _sy, 170 * _sx, 145 * _sy, false);

    draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(244, 211, 137));
    draw_set_font(_title);
    draw_text(_gw * 0.5, 20 * _sy, "FISHIN' WITH FISTS");
    draw_set_font(_font);
    draw_set_color(c_white);
    draw_text(_gw * 0.5, 52 * _sy, "ORCS DON'T USE FISHIN' RODS.");

    var _btn_w = 160 * _sx;
    var _btn_h = 33 * _sy;
    for (var _i = 0; _i < 2; _i++)
    {
        var _bx = _gw * 0.5 - _btn_w * 0.5;
        var _by = (236 + _i * 42) * _sy;
        draw_set_color(_i == shore_choice ? make_color_rgb(133, 88, 44) : make_color_rgb(34, 29, 24));
        draw_rectangle(_bx, _by, _bx + _btn_w, _by + _btn_h, false);
        draw_set_color(_i == shore_choice ? c_yellow : make_color_rgb(210, 194, 167));
        draw_rectangle(_bx, _by, _bx + _btn_w, _by + _btn_h, true);
        draw_text(_gw * 0.5, _by + 8 * _sy, _i == 0 ? "GO FISH" : "LEAVE");
    }
    draw_set_color(c_white);
    draw_text(_gw * 0.5, 335 * _sy, "W/S: CHOOSE   E: CONFIRM");
    if (global.evening_activity_used)
    {
        draw_set_color(c_yellow);
        draw_text(_gw * 0.5, 207 * _sy, "ALREADY SPENT YER EVENIN'!");
    }
    draw_set_halign(fa_left);
    draw_set_font(-1);
    draw_set_color(c_white);
    exit;
}

// ----------------------------------------------------
// BATTLE VIEW — old-school RPG with temporary shapes.
// ----------------------------------------------------
draw_set_color(make_color_rgb(67, 94, 102));
draw_rectangle(0, 0, _gw, 247 * _sy, false);
draw_set_color(make_color_rgb(56, 78, 72));
draw_rectangle(0, 168 * _sy, _gw, 247 * _sy, false);

var _jx = 0;
var _jy = 0;
if (shake_timer > 0)
{
    _jx = irandom_range(-shake_strength, shake_strength) * _sx;
    _jy = irandom_range(-shake_strength, shake_strength) * _sy;
}

// Enemy name + HP.
draw_set_color(make_color_rgb(19, 18, 17));
draw_rectangle(304 * _sx, 17 * _sy, 620 * _sx, 60 * _sy, false);
draw_set_color(make_color_rgb(230, 200, 144));
draw_text(315 * _sx, 24 * _sy, fish_name);
draw_set_color(make_color_rgb(81, 36, 35));
draw_rectangle(315 * _sx, 47 * _sy, 604 * _sx, 54 * _sy, false);
draw_set_color(make_color_rgb(205, 73, 56));
draw_rectangle(315 * _sx, 47 * _sy, (315 + 289 * fish_hp / max(1, fish_max_hp)) * _sx, 54 * _sy, false);

// FISH: plain rectangle, later sprite facing toward the camera.
var _fish_offset = (state == "chef_action" && impact_timer > 0) ? 7 * _sx : 0;
draw_set_color(impact_timer > 0 && state == "chef_action" ? c_white : make_color_rgb(156, 178, 194));
draw_rectangle(395 * _sx + _jx + _fish_offset, 87 * _sy + _jy, 473 * _sx + _jx + _fish_offset, 157 * _sy + _jy, false);
draw_set_color(make_color_rgb(27, 45, 57));
draw_rectangle(449 * _sx + _jx, 105 * _sy + _jy, 453 * _sx + _jx, 111 * _sy + _jy, false);

// CHEF: back-facing rectangle placeholder.
draw_set_color(impact_timer > 0 && state == "fish_action" ? c_white : make_color_rgb(86, 149, 62));
draw_rectangle(126 * _sx + _jx, 128 * _sy + _jy, 201 * _sx + _jx, 225 * _sy + _jy, false);
draw_set_color(make_color_rgb(121, 184, 83));
draw_rectangle(132 * _sx + _jx, 108 * _sy + _jy, 194 * _sx + _jx, 155 * _sy + _jy, false);

// Chef status.
draw_set_color(make_color_rgb(22, 20, 18));
draw_rectangle(11 * _sx, 14 * _sy, 240 * _sx, 60 * _sy, false);
draw_set_color(make_color_rgb(231, 204, 152));
draw_text(22 * _sx, 20 * _sy, "CHEF - FISHIN' LV " + string(global.fishing_level));
draw_set_color(make_color_rgb(86, 40, 35));
draw_rectangle(22 * _sx, 44 * _sy, 227 * _sx, 52 * _sy, false);
draw_set_color(make_color_rgb(93, 179, 89));
draw_rectangle(22 * _sx, 44 * _sy, (22 + 205 * chef_hp / max(1, chef_max_hp)) * _sx, 52 * _sy, false);

// ====================================================
// COMPACT BATTLE LOG — ABOVE THE HAND
// ====================================================
draw_set_halign(fa_center);
draw_set_font(_font);
draw_set_color(make_color_rgb(22, 21, 20));
draw_rectangle(0, 192 * _sy, _gw, 220 * _sy, false);
draw_set_color(make_color_rgb(241, 208, 157));
draw_text(_gw * 0.5, 198 * _sy, message);

// ====================================================
// HEARTHSTONE-STYLE HAND
// ====================================================
// Cards are intentionally larger/taller than before.
// Non-selected cards tuck behind the lower screen edge.
// Selected card rises and is drawn LAST (above neighbours).

if (state != "result")
{
    var _count = array_length(hand_cards);
    var _card_w = 120;
    var _card_h = 132;
    var _spacing = 94;
    var _cx = 320;

    // Draw unselected cards first so the selected card is in front.
    for (var _pass = 0; _pass < 2; _pass++)
    {
        for (var _h = 0; _h < _count; _h++)
        {
            var _is_selected = (_h == selected_card && state == "choose");
            if ((_pass == 0 && _is_selected) || (_pass == 1 && !_is_selected)) continue;

            var _card_id = hand_cards[_h];
            var _c = cards[_card_id];
            var _offset = _h - (_count - 1) * 0.5;
            var _x = _cx + _offset * _spacing;
            // Selection lift; the others are tucked into the lower edge.
            var _bob = _is_selected ? sin(hand_bob_timer * 0.075) * 2.4 : 0;
            var _y = (_is_selected ? 222 : 271) + abs(_offset) * 3 + _bob;
            var _w = _is_selected ? 132 : _card_w;
            var _hgt = _is_selected ? 134 : _card_h;
            var _l = (_x - _w * 0.5) * _sx;
            var _t = _y * _sy;
            var _r = (_x + _w * 0.5) * _sx;
            var _b = (_y + _hgt) * _sy;

            // Drop shadow, heavy frame, and coloured interior.
            draw_set_color(make_color_rgb(9, 9, 10));
            draw_rectangle(_l + 3 * _sx, _t + 4 * _sy, _r + 3 * _sx, _b + 4 * _sy, false);
            draw_set_color(_is_selected ? make_color_rgb(242, 209, 113) : make_color_rgb(133, 119, 92));
            draw_rectangle(_l, _t, _r, _b, false);
            draw_set_color(_c.color);
            draw_rectangle(_l + 4 * _sx, _t + 4 * _sy, _r - 4 * _sx, _b - 4 * _sy, false);
            draw_set_color(make_color_rgb(23, 22, 20));
            draw_rectangle(_l + 7 * _sx, _t + 7 * _sy, _r - 7 * _sx, _t + 28 * _sy, false);

            draw_set_font(_font);
            draw_set_color(c_white);
            draw_text(_x * _sx, _t + 11 * _sy, _c.name);

            // Large art placeholder. Later replace this panel with card illustration.
            draw_set_color(make_color_rgb(42, 39, 32));
            draw_rectangle(_l + 13 * _sx, _t + 33 * _sy, _r - 13 * _sx, _t + 77 * _sy, false);
            draw_set_color(make_color_rgb(221, 188, 127));
            if (_card_id == 0)
            {
                draw_circle(_x * _sx, _t + 54 * _sy, 12 * min(_sx, _sy), false);
            }
            else if (_card_id == 1)
            {
                draw_circle(_x * _sx, _t + 54 * _sy, 17 * min(_sx, _sy), true);
                draw_circle(_x * _sx, _t + 54 * _sy, 10 * min(_sx, _sy), false);
            }
            else
            {
                draw_rectangle((_x - 11) * _sx, _t + 43 * _sy, (_x + 11) * _sx, _t + 65 * _sy, true);
            }

            // Only raised selected card shows full description and remaining uses.
            if (_is_selected)
            {
                draw_set_color(make_color_rgb(24, 22, 20));
                draw_rectangle(_l + 7 * _sx, _t + 80 * _sy, _r - 7 * _sx, _b - 7 * _sy, false);
                draw_set_color(c_white);
                draw_text(_x * _sx, _t + 85 * _sy, _c.subtitle);
                var _uses = (_c.charges < 0) ? "UNLIMITED" : "USES " + string(_c.charges) + "/" + string(_c.max_charges);
                draw_set_color(make_color_rgb(244, 217, 145));
                draw_text(_x * _sx, _t + 111 * _sy, _uses);
            }
        }
    }

    // Hand hint outside the cards, unobtrusive in the battle view.
    draw_set_halign(fa_right);
    draw_set_font(_font);
    draw_set_color(make_color_rgb(229, 211, 177));
    if (state == "choose") draw_text(629 * _sx, 181 * _sy, "A/D: CARD   E: PLAY   ESC: RUN");
    draw_set_halign(fa_center);

    // ====================================================
    // PLAYED CARD — FLIES TOWARD CENTRE, HOLDS, THEN FADES
    // ====================================================
    if (state == "chef_action" && card_play_timer > 0 && is_struct(played_card))
    {
        var _p = 1 - card_play_timer / max(1, card_play_duration);
        var _ease = 1 - power(1 - clamp(_p * 3, 0, 1), 3);
        var _start_x = 320;
        var _start_y = 265;
        var _centre_x = 320;
        var _centre_y = 102;
        var _x = lerp(_start_x, _centre_x, _ease);
        var _y = lerp(_start_y, _centre_y, _ease);
        var _w = lerp(132, 148, _ease);
        var _h = lerp(134, 150, _ease);
        var _fade = clamp(card_play_timer / max(1, room_speed * 0.14), 0, 1);
        draw_set_alpha(_fade);
        draw_set_color(make_color_rgb(251, 222, 133));
        draw_rectangle((_x - _w * 0.5) * _sx, _y * _sy, (_x + _w * 0.5) * _sx, (_y + _h) * _sy, false);
        draw_set_color(played_card.color);
        draw_rectangle((_x - _w * 0.5 + 4) * _sx, (_y + 4) * _sy, (_x + _w * 0.5 - 4) * _sx, (_y + _h - 4) * _sy, false);
        draw_set_color(c_white);
        draw_set_font(_title);
        draw_text(_x * _sx, (_y + 16) * _sy, played_card.name);
        draw_set_font(_font);
        draw_text(_x * _sx, (_y + 82) * _sy, played_card.subtitle);
        draw_set_alpha(1);
    }
}
else
{
    draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(16, 17, 14));
    draw_rectangle(55 * _sx, 265 * _sy, 585 * _sx, 346 * _sy, false);
    draw_set_color(win ? make_color_rgb(162, 232, 118) : make_color_rgb(238, 127, 113));
    draw_set_font(_title);
    draw_text(_gw * 0.5, 276 * _sy, win ? "FISH DEFEATED!" : "FISHIN' OVER!");
    draw_set_font(_font);
    draw_set_color(c_white);
    draw_text(_gw * 0.5, 313 * _sy, result_text);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
draw_set_alpha(1);
draw_set_color(c_white);
