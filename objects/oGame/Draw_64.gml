
/// oGame — Draw GUI

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
var _font_hud     = PixelifyBold14;
var _font_small   = PixelifyRegular12;


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
// DAY PHASE LABEL
// ====================================================

var _phase_label = "DAYTIME";

switch (global.day_phase)
{
    case "pre_shift":
        _phase_label = "PREPARATION";
        break;

    case "serving":
        _phase_label = "SERVING";
        break;

    case "closing":
        _phase_label = "CLOSING";
        break;

    case "cleanup":
        _phase_label = "CLEANUP";
        break;

    case "shift_summary":
        _phase_label = "SHIFT ENDED";
        break;

    case "camp_map":
        _phase_label = "WAR CAMP";
        break;

    case "market":
        _phase_label = "MARKET";
        break;

    case "home":
        _phase_label = "HOME";
        break;
}


// ====================================================
// MAIN GAMEPLAY HUD
// ====================================================

if (room_get_name(room) != "MainMenuRoom")
{
    // ------------------------------------------------
    // LEFT PANEL — DAY / GOLD / PHASE
    // ------------------------------------------------

    var _lx = 8 * _sx;
    var _ly = 8 * _sy;
    var _lw = 164 * _sx;
    var _lh = 66 * _sy;

    _panel(
        _lx,
        _ly,
        _lx + _lw,
        _ly + _lh
    );

    draw_set_font(_font_hud);
    draw_set_color(_gold);

    draw_text(
        _lx + 10 * _sx,
        _ly + 7 * _sy,
        "DAY " + string(global.day)
    );

    draw_set_color(_parchment);

    draw_text(
        _lx + 10 * _sx,
        _ly + 26 * _sy,
        string(global.gold) + " GOLD"
    );

    draw_set_font(_font_small);
    draw_set_color(_muted);

    draw_text(
        _lx + 10 * _sx,
        _ly + 47 * _sy,
        _phase_label
    );


    // ------------------------------------------------
    // CENTRE PANEL — SHIFT TIMER
    // ------------------------------------------------

    var _show_timer = false;
    var _timer_title = "";
    var _timer_value = "";

    if (global.day_phase == "pre_shift")
    {
        _show_timer = true;
        _timer_title = "SHIFT BEGINS";

        var _seconds = max(
            0,
            ceil(global.pre_shift_timer / room_speed)
        );

        _timer_value =
            string(_seconds div 60)
            + ":"
            + string_format(_seconds mod 60, 2, 0);
    }
    else if (global.day_phase == "serving")
    {
        _show_timer = true;
        _timer_title = "TIME LEFT";

        var _seconds = max(
            0,
            ceil(global.shift_timer / room_speed)
        );

        _timer_value =
            string(_seconds div 60)
            + ":"
            + string_format(_seconds mod 60, 2, 0);
    }
    else if (global.day_phase == "closing")
    {
        _show_timer = true;
        _timer_title = "SHIFT";
        _timer_value = "CLOSING";
    }
    else if (global.day_phase == "cleanup")
    {
        _show_timer = true;
        _timer_title = "SHIFT";
        _timer_value = "FINISHED";
    }

    if (_show_timer)
    {
        var _tw = 142 * _sx;
        var _tx = _cx - _tw * 0.5;
        var _ty = 8 * _sy;

        _panel(
            _tx,
            _ty,
            _tx + _tw,
            _ty + 53 * _sy
        );

        draw_set_halign(fa_center);
        draw_set_valign(fa_top);

        draw_set_font(_font_small);
        draw_set_color(_muted);

        draw_text(
            _cx,
            _ty + 6 * _sy,
            _timer_title
        );

        draw_set_font(_font_heading);
        draw_set_color(_gold);

        draw_text(
            _cx,
            _ty + 23 * _sy,
            _timer_value
        );

        draw_set_halign(fa_left);
    }


    // ------------------------------------------------
    // RIGHT PANEL — CUSTOMERS / EARNINGS
    // ------------------------------------------------

    if (
        global.day_phase == "pre_shift"
        || global.day_phase == "serving"
        || global.day_phase == "closing"
        || global.day_phase == "cleanup"
    )
    {
        var _rw = 164 * _sx;
        var _rx = _gw - _rw - 8 * _sx;
        var _ry = 8 * _sy;

        _panel(
            _rx,
            _ry,
            _rx + _rw,
            _ry + 54 * _sy
        );

        draw_set_font(_font_small);
        draw_set_color(_muted);

        draw_text(
            _rx + 10 * _sx,
            _ry + 7 * _sy,
            "CUSTOMERS SERVED"
        );

        draw_set_font(_font_hud);
        draw_set_color(_parchment);

        draw_text(
            _rx + 10 * _sx,
            _ry + 22 * _sy,
            string(global.customers_served)
            + "/"
            + string(global.customers_spawned)
        );

        draw_set_color(_gold);

        draw_text(
            _rx + 78 * _sx,
            _ry + 22 * _sy,
            "+" + string(global.shift_revenue) + " G"
        );
    }
}


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

    draw_text(
        _cx,
        _by + _bh * 0.5,
        global.shift_banner_text
    );

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
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
// PAUSE OVERLAY
// ====================================================

if (global.paused)
{
    draw_set_alpha(0.72);
    draw_set_color(c_black);

    draw_rectangle(
        0, 0,
        _gw, _gh,
        false
    );

    draw_set_alpha(1);

    var _pw = 260 * _sx;
    var _ph = 110 * _sy;

    var _px = _cx - _pw * 0.5;
    var _py = _gh * 0.5 - _ph * 0.5;

    _panel(
        _px,
        _py,
        _px + _pw,
        _py + _ph
    );

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_set_font(_font_title);
    draw_set_color(_gold);

    draw_text(
        _cx,
        _py + 39 * _sy,
        "PAUSED"
    );

    draw_set_font(_font_small);
    draw_set_color(_parchment);

    draw_text(
        _cx,
        _py + 81 * _sy,
        "THE WAR CAN WAIT..."
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
