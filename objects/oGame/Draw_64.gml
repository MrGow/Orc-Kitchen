/// oGame — Draw GUI

// ====================================================
// ORC SURVIVORS — HIDE MAIN GAME HUD
// ====================================================

// The arcade minigame uses its own HUD.
// Suppress the regular Orc Kitchen interface.

if (room == OrcSurvivorsRoom)
{
    exit;
}

// Main menu uses its own UI.
if (room == MainMenuRoom)
{
    exit;
}
// ====================================================
// ORC KITCHEN — FANTASY HUD
// ====================================================

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

if (_gw <= 0) _gw = global.GUI_W;
if (_gh <= 0) _gh = global.GUI_H;

var _sx = _gw / 640;
var _sy = _gh / 360;
var _cx = _gw * 0.5;


// ====================================================
// FONTS
// ====================================================

var _font_title   = MedievalSharpRegular32;
var _font_heading = MedievalSharpRegular20;
var _font_body    = AlmendraRegular16;
var _font_bold    = AlmendraBold16;
var _font_hud     = Silkscreen12;
var _font_small   = Silkscreen10;


// ====================================================
// COLOURS
// ====================================================

var _gold = make_color_rgb(232, 190, 105);
var _parchment = make_color_rgb(225, 204, 165);
var _ink = make_color_rgb(60, 42, 29);
var _muted = make_color_rgb(165, 146, 122);
var _green = make_color_rgb(92, 128, 58);
var _red = make_color_rgb(185, 91, 75);


// ====================================================
// PANEL DRAWING FUNCTION
// ====================================================
// Colours are declared inside the function to avoid
// GML local-variable scope errors.

var _panel = function(_x1, _y1, _x2, _y2)
{
    var _wood = make_color_rgb(48, 35, 29);
    var _wood_light = make_color_rgb(72, 51, 37);
    var _iron = make_color_rgb(112, 101, 89);
    var _rivet = make_color_rgb(232, 190, 105);

    // Shadow
    draw_set_alpha(0.45);
    draw_set_color(c_black);

    draw_rectangle(
        _x1 + 2, _y1 + 3,
        _x2 + 2, _y2 + 3,
        false
    );

    draw_set_alpha(1);

    // Timber background
    draw_set_color(_wood);

    draw_rectangle(
        _x1, _y1,
        _x2, _y2,
        false
    );

    // Iron border
    draw_set_color(_iron);

    draw_rectangle(
        _x1, _y1,
        _x2, _y2,
        true
    );

    // Inner border
    draw_set_color(_wood_light);

    draw_rectangle(
        _x1 + 3, _y1 + 3,
        _x2 - 3, _y2 - 3,
        true
    );

    // Corner rivets
    draw_set_color(_rivet);

    draw_rectangle(
        _x1 + 3, _y1 + 3,
        _x1 + 4, _y1 + 4,
        false
    );

    draw_rectangle(
        _x2 - 4, _y1 + 3,
        _x2 - 3, _y1 + 4,
        false
    );

    draw_rectangle(
        _x1 + 3, _y2 - 4,
        _x1 + 4, _y2 - 3,
        false
    );

    draw_rectangle(
        _x2 - 4, _y2 - 4,
        _x2 - 3, _y2 - 3,
        false
    );
};


// ====================================================
// PARCHMENT PANEL DRAWING FUNCTION
// ====================================================

var _paper_panel = function(_x1, _y1, _x2, _y2)
{
    var _wood = make_color_rgb(48, 35, 29);
    var _iron = make_color_rgb(112, 101, 89);
    var _paper = make_color_rgb(225, 204, 165);
    var _border = make_color_rgb(159, 120, 79);

    // Wooden backing
    draw_set_color(_wood);

    draw_rectangle(
        _x1 - 5, _y1 - 5,
        _x2 + 5, _y2 + 5,
        false
    );

    // Outer border
    draw_set_color(_iron);

    draw_rectangle(
        _x1 - 5, _y1 - 5,
        _x2 + 5, _y2 + 5,
        true
    );

    // Parchment
    draw_set_color(_paper);

    draw_rectangle(
        _x1, _y1,
        _x2, _y2,
        false
    );

    // Inner border
    draw_set_color(_border);

    draw_rectangle(
        _x1 + 4, _y1 + 4,
        _x2 - 4, _y2 - 4,
        true
    );
};


// ====================================================
// DEFAULT DRAW STATE
// ====================================================

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);


// ====================================================
// CRISP DARK SHADOW FOR TEXT ON WOODEN HUD PANELS
// ====================================================
// Reads the current font, colour and alignment.
// Draws one dark pixel of separation, then the original.
// Parchment pages retain their normal unshadowed ink.
var _hud_text = function(_x, _y, _str)
{
    var _col = draw_get_color();
    draw_set_color(make_color_rgb(19, 12, 12));
    draw_text(_x + 1, _y + 1, _str);
    draw_set_color(_col);
    draw_text(_x, _y, _str);
};


// ====================================================
// COMPACT CORNER HUD — NO PERMANENT CENTRE BOX
// ====================================================
// The day phase is independent of the room currently visited.
var _phase_label = "EVENING";
var _phase_time = "";
var _timer_frames = 0;

switch (global.day_phase)
{
    case "pre_shift":
        _phase_label = "PRE-SHIFT";
        _timer_frames = max(0, global.pre_shift_timer);
        break;
    case "serving":
        _phase_label = "SERVING";
        _timer_frames = max(0, global.shift_timer);
        break;
    case "closing":
        _phase_label = "LAST CALL";
        // Closing has a timer, but the small UI does not require it.
        break;
    case "shift_summary":
        _phase_label = "SHIFT ENDED";
        break;
    case "cleanup":
        _phase_label = "CLEANUP";
        break;
    case "evening":
        _phase_label = "EVENING";
        break;
    default:
        _phase_label = "DAYTIME";
        break;
}

if (global.day_phase == "pre_shift" || global.day_phase == "serving")
{
    var _seconds_remaining = ceil(_timer_frames / room_speed);
    _phase_time = " " + string(_seconds_remaining div 60)
        + ":" + string_format(_seconds_remaining mod 60, 2, 0);
}

// ----------------------------------------------------
// TOP LEFT: one compact wooden panel, three lines.
// ----------------------------------------------------
var _hud_x = 8 * _sx;
var _hud_y = 7 * _sy;
var _hud_w = 164 * _sx;
var _hud_h = 58 * _sy;

_panel(_hud_x, _hud_y, _hud_x + _hud_w, _hud_y + _hud_h);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(_font_hud);
draw_set_color(_gold);
_hud_text(_hud_x + 9 * _sx, _hud_y + 5 * _sy, "DAY " + string(global.day));

draw_set_font(_font_small);
draw_set_color(_parchment);
_hud_text(_hud_x + 9 * _sx, _hud_y + 25 * _sy, _phase_label + _phase_time);

draw_set_color(_muted);
_hud_text(_hud_x + 9 * _sx, _hud_y + 41 * _sy,
    "SERVED " + string(global.customers_served) + "/" + string(global.customers_spawned));

// ----------------------------------------------------
// TOP RIGHT: unboxed pile-of-gold icon + total (+/- today).
// The gold pile is procedural until a proper sprite is supplied.
// If asset spriteGoldPile is added, it is used automatically.
// ----------------------------------------------------
var _baseline = 0;
if (variable_global_exists("day_start_gold")) _baseline = global.day_start_gold;
var _gain = global.gold - _baseline;
var _delta = "(" + ((_gain >= 0) ? "+" : "") + string(_gain) + ")";

var _gold_total_str = string(global.gold);
var _gold_x_end = _gw - 8 * _sx;
var _gold_y = 11 * _sy;

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(_font_small);
var _delta_w = string_width(_delta);
draw_set_font(_font_hud);
var _total_w = string_width(_gold_total_str);

var _total_x = _gold_x_end - _delta_w - 6 * _sx - _total_w;
var _delta_x = _gold_x_end - _delta_w;
var _icon_x = _total_x - 13 * _sx;
var _icon_y = _gold_y + 6 * _sy;

// Tiny dark shadows for legibility against bright room backgrounds.
draw_set_color(c_black);
draw_set_alpha(0.40);
draw_roundrect(_icon_x - 10 * _sx, _gold_y - 3 * _sy,
    _gold_x_end + 3 * _sx, _gold_y + 25 * _sy, false);
draw_set_alpha(1);

var _pile = asset_get_index("spriteGoldPile");
if (_pile != -1)
{
    draw_sprite_ext(_pile, 0, _icon_x, _icon_y, 0.5 * _sx, 0.5 * _sy,
        0, c_white, 1);
}
else
{
    // Three small golden coins; temporary asset-free placeholder.
    draw_set_color(make_color_rgb(125, 77, 25));
    draw_ellipse(_icon_x - 7 * _sx, _icon_y - 1 * _sy,
        _icon_x + 4 * _sx, _icon_y + 7 * _sy, false);
    draw_set_color(_gold);
    draw_ellipse(_icon_x - 8 * _sx, _icon_y - 3 * _sy,
        _icon_x + 3 * _sx, _icon_y + 4 * _sy, false);
    draw_ellipse(_icon_x - 1 * _sx, _icon_y - 7 * _sy,
        _icon_x + 8 * _sx, _icon_y, false);
}

draw_set_font(_font_hud);
draw_set_color(_gold);
_hud_text(_total_x, _gold_y, _gold_total_str);

draw_set_font(_font_small);
draw_set_color((_gain >= 0) ? make_color_rgb(129, 205, 107)
                             : make_color_rgb(228, 112, 97));
_hud_text(_delta_x, _gold_y + 3 * _sy, _delta);

draw_set_color(c_white);
draw_set_alpha(1);

// ====================================================
// SHIFT ANNOUNCEMENT BANNER
// ====================================================

if (
    global.shift_banner_timer > 0
    && global.shift_banner_text != ""
)
{
    var _by = _gh * 0.36;
    var _bh = 58 * _sy;

    draw_set_alpha(0.88);
    draw_set_color(make_color_rgb(48, 35, 29));

    draw_rectangle(
        0,
        _by,
        _gw,
        _by + _bh,
        false
    );

    draw_set_alpha(1);
    draw_set_color(_gold);

    draw_line(
        0, _by,
        _gw, _by
    );

    draw_line(
        0, _by + _bh,
        _gw, _by + _bh
    );

    draw_set_font(_font_heading);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    _hud_text(
        _cx,
        _by + _bh * 0.5,
        global.shift_banner_text
    );

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}


// ====================================================
// PAUSE MENU OVERLAY
// ====================================================
if (variable_global_exists("pause_menu_open") && global.pause_menu_open)
{
    draw_set_alpha(0.78);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);

    var _pw = 302 * _sx;
    var _ph = 296 * _sy;
    var _px = _cx - _pw * 0.5;
    var _py = (_gh - _ph) * 0.5;

    _panel(_px, _py, _px + _pw, _py + _ph);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(_font_title);
    draw_set_color(_gold);
    _hud_text(_cx, _py + 41 * _sy, "PAUSED");

    draw_set_color(make_color_rgb(117, 91, 65));
    draw_line(_px + 30 * _sx, _py + 69 * _sy,
              _px + _pw - 30 * _sx, _py + 69 * _sy);

    var _labels = ["RESUME", "SETTINGS", "QUIT TO MENU", "QUIT TO DESKTOP"];
    var _row_h = 45 * _sy;
    var _row_y = _py + 93 * _sy;
    var _sel = global.pause_menu_index;

    draw_set_font(_font_hud);
    for (var _i = 0; _i < 4; _i++)
    {
        var _yy = _row_y + _i * _row_h;
        var _disabled = (_i == 1);
        var _selected = (_sel == _i && !_disabled);

        if (_selected)
        {
            draw_set_color(make_color_rgb(89, 65, 40));
            draw_rectangle(_px + 21 * _sx, _yy - 16 * _sy,
                           _px + _pw - 21 * _sx, _yy + 17 * _sy, false);
            draw_set_color(_gold);
            draw_rectangle(_px + 21 * _sx, _yy - 16 * _sy,
                           _px + _pw - 21 * _sx, _yy + 17 * _sy, true);
            _hud_text(_px + 35 * _sx, _yy, ">");
        }

        if (_disabled) draw_set_color(make_color_rgb(103, 94, 88));
        else if (_selected) draw_set_color(_gold);
        else draw_set_color(_parchment);

        _hud_text(_cx, _yy, _labels[_i]);
    }

    draw_set_font(_font_small);
    draw_set_color(_muted);
    _hud_text(_cx, _py + _ph - 17 * _sy, "ESC: BACK    E / A: SELECT");

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_set_alpha(1);
    exit;
}

// ====================================================
// SHIFT SUMMARY OVERLAY
// ====================================================

if (global.day_phase == "shift_summary")
{
    // Dark background
    draw_set_alpha(0.82);
    draw_set_color(c_black);

    draw_rectangle(
        0, 0,
        _gw, _gh,
        false
    );

    draw_set_alpha(1);

    // Parchment report
    var _px = 124 * _sx;
    var _py = 20 * _sy;
    var _pw = 392 * _sx;
    var _ph = 320 * _sy;

    _paper_panel(
        _px,
        _py,
        _px + _pw,
        _py + _ph
    );

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);

    draw_set_font(_font_heading);
    draw_set_color(_ink);

    draw_text(
        _cx,
        _py + 15 * _sy,
        "SHIFT ENDED"
    );

    // Divider
    draw_set_color(make_color_rgb(130, 88, 50));

    draw_line(
        _px + 32 * _sx,
        _py + 48 * _sy,
        _px + _pw - 32 * _sx,
        _py + 48 * _sy
    );


    // ------------------------------------------------
    // SUMMARY STATISTICS
    // ------------------------------------------------

    var _labels =
    [
        "Gold earned",
        "Tips",
        "Net profit",
        "Customers served",
        "Customers failed",
        "Left angry",
        "Food wasted",
        "Waste cost"
    ];

    var _values =
    [
        global.shift_revenue,
        global.shift_tips,
        global.shift_net_profit,
        global.customers_served,
        global.customers_failed,
        global.customers_left_angry,
        global.food_wasted,
        global.waste_cost
    ];

    var _row_y = _py + 61 * _sy;
    var _row_gap = 25 * _sy;

    draw_set_font(_font_body);

    for (var i = 0; i < array_length(_labels); i++)
    {
        var _yy = _row_y + i * _row_gap;

        draw_set_halign(fa_left);
        draw_set_color(_ink);

        draw_text(
            _px + 38 * _sx,
            _yy,
            _labels[i]
        );

        draw_set_halign(fa_right);

        if (i == 2)
        {
            if (_values[i] >= 0)
            {
                draw_set_color(_green);
            }
            else
            {
                draw_set_color(_red);
            }
        }
        else
        {
            draw_set_color(_ink);
        }

        draw_text(
            _px + _pw - 38 * _sx,
            _yy,
            string(_values[i])
        );
    }


    // ------------------------------------------------
    // CONTINUE PROMPT
    // ------------------------------------------------

    if (global.summary_timer >= global.summary_min_time)
    {
        draw_set_halign(fa_center);
        draw_set_font(_font_small);
        draw_set_color(_ink);

        draw_text(
            _cx,
            _py + _ph - 32 * _sy,
            "PRESS SPACE / ENTER / E TO CONTINUE"
        );
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
    draw_set_color(c_white);

    exit;
}


// ====================================================
// RECIPE BOOK OVERLAY
// ====================================================

if (global.recipe_menu_open)
{
    // Darken background
    draw_set_alpha(0.76);
    draw_set_color(c_black);

    draw_rectangle(
        0, 0,
        _gw, _gh,
        false
    );

    draw_set_alpha(1);


    // ------------------------------------------------
    // PARCHMENT BOOK
    // ------------------------------------------------

    var _px = 58 * _sx;
    var _py = 22 * _sy;
    var _pw = 524 * _sx;
    var _ph = 316 * _sy;

    _paper_panel(
        _px,
        _py,
        _px + _pw,
        _py + _ph
    );


    // ------------------------------------------------
    // TITLE
    // ------------------------------------------------

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);

    draw_set_font(_font_heading);
    draw_set_color(_ink);

    draw_text(
        _cx,
        _py + 13 * _sy,
        "GREASE-STAINED WAR COOKBOOK"
    );

    draw_set_color(make_color_rgb(139, 93, 54));

    draw_line(
        _px + 30 * _sx,
        _py + 44 * _sy,
        _px + _pw - 30 * _sx,
        _py + 44 * _sy
    );


    // ------------------------------------------------
    // RECIPE NAME
    // ------------------------------------------------

    draw_set_font(_font_bold);
    draw_set_color(_ink);

    draw_text(
        _cx,
        _py + 50 * _sy,
        "Skewered Rat"
    );


    // ------------------------------------------------
    // FOOD PREVIEW
    // ------------------------------------------------

    var _food_sprite =
        asset_get_index("spriteFoodFinalSkeweredRat");

    if (_food_sprite != -1)
    {
        draw_sprite(
            _food_sprite,
            0,
            _cx,
            _py + 99 * _sy
        );
    }


    // ------------------------------------------------
    // INGREDIENTS AND INSTRUCTIONS
    // ------------------------------------------------

    draw_set_halign(fa_left);

    var _text_x = _px + 34 * _sx;
    var _text_y = _py + 129 * _sy;
    var _line = 21 * _sy;

    draw_set_font(_font_bold);
    draw_set_color(_ink);

    draw_text(
        _text_x,
        _text_y,
        "NEEDS:"
    );

    draw_set_font(_font_body);

    draw_text(
        _text_x + 74 * _sx,
        _text_y,
        "Normal Plate, Raw Rat, Grill"
    );

    _text_y += 29 * _sy;

    draw_set_font(_font_bold);

    draw_text(
        _text_x,
        _text_y,
        "METHOD:"
    );

    _text_y += 20 * _sy;

    draw_set_font(_font_body);

    var _steps =
    [
        "1. Grab a Clean Plate from the Plate Holder.",
        "2. Grab Raw Skewered Rat from the Meat Rack.",
        "3. Grill the rat until the bar reaches cooked.",
        "4. Put Plate + Cooked Rat on the Prep Counter.",
        "5. Smoke pop = finished Skewered Rat.",
        "6. Serve it to the correct customer table seat."
    ];

    for (var i = 0; i < array_length(_steps); i++)
    {
        draw_text(
            _text_x + 12 * _sx,
            _text_y + i * _line,
            _steps[i]
        );
    }


    // ------------------------------------------------
    // CLOSE PROMPT
    // ------------------------------------------------

    draw_set_halign(fa_center);
    draw_set_font(_font_small);
    draw_set_color(_ink);

    draw_text(
        _cx,
        _py + _ph - 24 * _sy,
        "PRESS R / XBOX SELECT TO CLOSE"
    );

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
    draw_set_color(c_white);

    exit;
}


// ====================================================
// RESET DRAW STATE
// ====================================================

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_set_color(c_white);
