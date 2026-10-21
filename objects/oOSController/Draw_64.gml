/// oOSController — Draw GUI (FULL REPLACEMENT)

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
// Orc Survivors uses its own retro arcade fonts.
// Required GameMaker font assets:
// Silkscreen10 (regular), Silkscreen12 (bold), PressStart10, PressStart16.
var _body_font  = Silkscreen12;
var _small_font = Silkscreen10;
var _title_font = PressStart16;
var _head_font  = PressStart10;

// Text fitting helper: preserves proportions when long messages exceed the GUI.
function _os_draw_center_fit(_xx, _yy, _label, _wanted_scale, _max_width)
{
    var _natural_width = max(1, string_width(_label));
    var _s = min(_wanted_scale, _max_width / _natural_width);
    draw_text_transformed(_xx, _yy, _label, _s, _s, 0);
}

draw_set_font(_body_font);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// ====================================================
// ARCADE TITLE — PAUSES ALL COMBAT UNTIL CONFIRMATION
// ====================================================
if (os_state == "title")
{
    var _cx = _gw * 0.5;
    var _cy = _gh * 0.5;
    var _logo = title_logo_sprite;

    draw_set_alpha(1);
    draw_set_color(make_color_rgb(12, 19, 13));
    draw_rectangle(0, 0, _gw, _gh, false);

    // Decorative arcade cabinet lines.
    draw_set_color(make_color_rgb(55, 74, 40));
    draw_rectangle(20, 18, _gw - 20, _gh - 18, true);
    draw_set_color(make_color_rgb(96, 112, 52));
    draw_rectangle(24, 22, _gw - 24, _gh - 22, true);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(_small_font);
    draw_set_color(make_color_rgb(165, 186, 136));
    draw_text(_cx, 39, "A GOBLIN ENTERTAINMENT PRODUCTION");

    // Supply optional sprite sprOSLogo later; placeholder until then.
    if (_logo != -1)
    {
        var _scale = min(1, min((_gw - 100) / max(1, sprite_get_width(_logo)),
                                  116 / max(1, sprite_get_height(_logo))));
        draw_sprite_ext(_logo, 0, _cx, 116, _scale, _scale, 0, c_white, 1);
    }
    else
    {
        draw_set_font(_title_font);
        draw_set_color(make_color_rgb(174, 214, 107));
        _os_draw_center_fit(_cx, 102, "ORC SURVIVORS", 1.65, _gw - 90);
        draw_set_font(_small_font);
        draw_set_color(make_color_rgb(234, 178, 95));
        draw_text(_cx, 140, "100% HISTORICALLY ACCURATE");
    }

    var _checkpoint = 1;
    if (variable_global_exists("os_wave"))
        _checkpoint = max(1, global.os_wave);

    draw_set_color(make_color_rgb(32, 43, 31));
    draw_rectangle(_cx - 190, 174, _cx + 190, 239, false);
    draw_set_color(make_color_rgb(101, 126, 73));
    draw_rectangle(_cx - 190, 174, _cx + 190, 239, true);

    draw_set_font(_body_font);
    draw_set_color(make_color_rgb(244, 215, 150));
    draw_text(_cx, 189, "CAMPAIGN: " + string(min(50, _checkpoint - 1)) + " / 50 WAVES");
    if (_checkpoint <= 1)
    {
        draw_set_color(c_white);
        draw_text(_cx, 217, "NEXT: WAVES 1-10");
    }
    else
    {
        draw_set_color(make_color_rgb(202, 200, 157));
        draw_text(_cx, 217, "NEXT: WAVE " + string(_checkpoint) + " (COMING SOON)");
    }

    // Slow pulse, visible longer than invisible.
    var _blink = ((floor(title_frame / max(1, round(room_speed * 0.55))) mod 2) == 0);
    if (_blink)
    {
        draw_set_font(_head_font);
        draw_set_color(make_color_rgb(250, 225, 155));
        if (_checkpoint <= 1)
            draw_text(_cx, 278, "SPACE - SLAUGHTER ELVES!");
        else
            draw_text(_cx, 278, "SPACE - REPLAY WAVES 1-10");
    }

    draw_set_font(_small_font);
    draw_set_color(make_color_rgb(160, 175, 145));
    draw_text(_cx, 326, "ESC / BACKSPACE - HOME (NO EVENING SPENT)");

    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_font(-1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    exit;
}

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
    _os_draw_center_fit(_gw * 0.5, _gh * 0.40, "DA ELVES CHEATED", 1.25, _gw - 60);
    draw_set_color(make_color_rgb(225, 84, 63));
    _os_draw_center_fit(_gw * 0.5, _gh * 0.53, "AND YOU LOST!", 1.35, _gw - 60);
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
    _os_draw_center_fit(_gw * 0.5, _gh * 0.34, "DA BIG ELF GOT SMASHED!", 1.1, _gw - 60);
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
draw_set_halign(fa_right);

draw_text(
    display_get_gui_width() - 16,
    13,
    "NEXT WAVE: " + string(max(0, ceil(wave_timer / room_speed))) + "s"
);

draw_set_halign(fa_left);

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
    draw_set_font(_head_font);
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
    draw_set_font(_head_font);
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
        draw_set_font(_small_font);
        draw_text(_left + 14, _yy + 31, _item.desc);
        draw_set_font(_body_font);
        if (upgrade_selected == _i)
        {
            draw_set_halign(fa_right);
            draw_set_color(make_color_rgb(255, 214, 130));
            draw_text(_right - 13, _yy + 8, "<");
        }
    }
    draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(217, 202, 171));
    draw_set_font(_small_font);
    draw_text(_gw * 0.5, _gh - 28, "W/S: SELECT    E/ENTER/SPACE: TAKE");
}

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
