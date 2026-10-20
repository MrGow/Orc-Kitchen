/// oOSController — Draw GUI (FULL REPLACEMENT)

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _body_font = asset_get_index("PixelifyRegular12");
var _title_font = asset_get_index("PixelifyBold14");
if (_title_font == -1) _title_font = _body_font;

draw_set_font(_body_font);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Defeat screen (preserves the existing joke).
if (os_state == "game_over")
{
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(19, 9, 8));
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_color(make_color_rgb(115, 38, 29));
    draw_rectangle(0, _gh * 0.20, _gw, _gh * 0.20 + 3, false);
    draw_rectangle(0, _gh * 0.80, _gw, _gh * 0.80 + 3, false);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(198, 118, 88));
    draw_text(_gw * 0.5, _gh * 0.26, "ORC SURVIVORS - DEFEAT");
    draw_set_font(_title_font);
    draw_set_color(make_color_rgb(245, 215, 170));
    draw_text_transformed(_gw * 0.5, _gh * 0.40, "DA ELVES CHEATED", 1.65, 1.65, 0);
    draw_set_color(make_color_rgb(225, 84, 63));
    draw_text_transformed(_gw * 0.5, _gh * 0.53, "AND YOU LOST!", 1.85, 1.85, 0);
    draw_set_font(_body_font);
    draw_set_color(make_color_rgb(206, 177, 142));
    draw_text(_gw * 0.5, _gh * 0.66, "STUPID POINTY-EARED GITS!");
    draw_set_color(make_color_rgb(170, 154, 133));
    draw_text(_gw * 0.5, _gh * 0.87, "RETURNING HOME IN " + string(max(1, ceil(defeat_timer / room_speed))) + "...");
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_font(-1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    exit;
}

// End-of-session victory screen.
if (os_state == "victory")
{
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(12, 27, 13));
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(_title_font);
    draw_set_color(make_color_rgb(243, 212, 117));
    draw_text_transformed(_gw * 0.5, _gh * 0.34, "DA BIG ELF GOT SMASHED!", 1.35, 1.35, 0);
    draw_set_font(_body_font);
    draw_set_color(c_white);
    draw_text(_gw * 0.5, _gh * 0.53, "WAVES 1-10 COMPLETE!");
    draw_text(_gw * 0.5, _gh * 0.64, "ARCADE PROGRESS SAVED: WAVE 11");
    draw_text(_gw * 0.5, _gh * 0.80, "GO HOME, YA LEGEND!");
    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_set_font(-1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    exit;
}

// Normal HUD: wave/health/XP. XP orbs and kills update the level.
draw_set_alpha(0.82);
draw_set_color(c_black);
draw_rectangle(8, 8, 180, 88, false);
draw_set_alpha(1);
draw_set_font(_body_font);
draw_set_color(make_color_rgb(238, 196, 106));
draw_text(16, 12, "ORC SURVIVORS");
draw_set_color(c_white);
draw_text(16, 32, "WAVE " + string(current_wave) + " / 10");
draw_set_color(make_color_rgb(217, 187, 123));
draw_text(199, 13, "NEXT WAVE: " + string(max(0, ceil(wave_timer / room_speed))) + "s");

if (instance_exists(oOSPlayer))
{
    var _p = instance_find(oOSPlayer, 0);
    var _health = clamp(_p.hp / max(1, _p.max_hp), 0, 1);
    var _progress = clamp(_p.xp / max(1, _p.xp_next), 0, 1);
    draw_set_color(make_color_rgb(63, 43, 40));
    draw_rectangle(16, 54, 168, 64, false);
    draw_set_color(make_color_rgb(182, 63, 49));
    draw_rectangle(18, 56, 18 + 148 * _health, 62, false);
    draw_set_color(make_color_rgb(49, 58, 63));
    draw_rectangle(16, 70, 168, 80, false);
    draw_set_color(make_color_rgb(78, 198, 230));
    draw_rectangle(18, 72, 18 + 148 * _progress, 78, false);
    draw_set_color(c_white);
    draw_text(187, 51, "LV " + string(_p.level));
}

draw_set_halign(fa_right);
draw_set_color(c_white);
draw_text(_gw - 12, _gh - 23, "BACKSPACE - HOME");

// Boss health bar — visible once the Wave 10 boss appears.
if (current_wave == 10 && instance_exists(boss_id))
{
    var _bar_w = min(440, _gw - 70);
    var _bar_x = (_gw - _bar_w) * 0.5;
    var _bar_y = 107;
    var _fraction = clamp(boss_id.hp / max(1, boss_id.max_hp), 0, 1);
    draw_set_halign(fa_center);
    draw_set_font(_title_font);
    draw_set_color(make_color_rgb(255, 186, 140));
    draw_text(_gw * 0.5, _bar_y - 25, string_upper(boss_name));
    draw_set_color(c_black);
    draw_rectangle(_bar_x - 2, _bar_y - 2, _bar_x + _bar_w + 2, _bar_y + 16, false);
    draw_set_color(make_color_rgb(82, 31, 30));
    draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + 14, false);
    draw_set_color(make_color_rgb(211, 53, 47));
    draw_rectangle(_bar_x + 2, _bar_y + 2, _bar_x + 2 + (_bar_w - 4) * _fraction, _bar_y + 12, false);
    draw_set_halign(fa_left);
    draw_set_font(_body_font);
}

// Level-up overlay, at Draw GUI depth after the HUD.
if (os_state == "level_up")
{
    draw_set_alpha(0.88);
    draw_set_color(make_color_rgb(15, 13, 12));
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);
    draw_set_halign(fa_center);
    draw_set_font(_title_font);
    draw_set_color(make_color_rgb(245, 199, 112));
    draw_text(_gw * 0.5, 22, "LEVEL UP! PICK YER LOOT!");
    draw_set_font(_body_font);
    draw_set_color(make_color_rgb(193, 175, 146));
    draw_text(_gw * 0.5, 49, "NORMAL / MAGIC / RARE");

    var _left = max(8, (_gw - 480) * 0.5);
    var _right = min(_gw - 8, _left + 480);
    for (var _i = 0; _i < array_length(upgrade_choices); _i++)
    {
        var _item = upgrade_choices[_i];
        var _yy = 85 + _i * 70;
        draw_set_color(upgrade_selected == _i ? make_color_rgb(78, 61, 41) : make_color_rgb(39, 32, 28));
        draw_rectangle(_left, _yy, _right, _yy + 61, false);
        draw_set_color(upgrade_selected == _i ? make_color_rgb(239, 192, 91) : make_color_rgb(105, 86, 65));
        draw_rectangle(_left, _yy, _right, _yy + 61, true);
        draw_set_halign(fa_left);
        var _rarity_color = make_color_rgb(210, 207, 199);
        if (_item.rarity == "MAGIC") _rarity_color = make_color_rgb(125, 183, 255);
        if (_item.rarity == "RARE") _rarity_color = make_color_rgb(241, 184, 77);
        draw_set_color(_rarity_color);
        draw_text(_left + 14, _yy + 8, _item.rarity + " - " + _item.name);
        draw_set_color(c_white);
        draw_text(_left + 14, _yy + 31, _item.desc);
        if (upgrade_selected == _i)
        {
            draw_set_halign(fa_right);
            draw_set_color(make_color_rgb(255, 214, 130));
            draw_text(_right - 13, _yy + 8, "<");
        }
    }
    draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(217, 202, 171));
    draw_text(_gw * 0.5, _gh - 28, "W/S: SELECT    E/ENTER/SPACE: TAKE");
}

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
