
/// oOrderTicketController — Draw GUI End
/// FULL REPLACEMENT
/// Open background, narrow horizontal pole and hanging tickets.

if (room != MessHall) exit;

if (global.day_phase != "serving"
    && global.day_phase != "closing")
{
    exit;
}

// ====================================================
// GUI / COLOURS
// ====================================================

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

var _sx = _gw / 640;
var _sy = _gh / 360;

var _gold = make_color_rgb(238, 195, 109);
var _ink = make_color_rgb(61, 43, 27);

var _pole_dark = make_color_rgb(74, 44, 25);
var _pole_main = make_color_rgb(171, 105, 48);
var _pole_light = make_color_rgb(212, 146, 74);

var _hook_dark = make_color_rgb(55, 48, 43);
var _hook_light = make_color_rgb(137, 119, 91);

// ====================================================
// HORIZONTAL POLE
// ====================================================
// No opaque footer background.
// Gameplay remains visible between the tickets.

var _pole_y = 271 * _sy;

draw_set_alpha(1);

draw_set_color(_pole_dark);
draw_rectangle(
    0,
    _pole_y,
    _gw,
    _pole_y + 6 * _sy,
    false
);

draw_set_color(_pole_main);
draw_rectangle(
    0,
    _pole_y + 1 * _sy,
    _gw,
    _pole_y + 4 * _sy,
    false
);

draw_set_color(_pole_light);
draw_line(
    0,
    _pole_y + 1 * _sy,
    _gw,
    _pole_y + 1 * _sy
);

// Small dark line below for depth.
draw_set_color(_pole_dark);
draw_line(
    0,
    _pole_y + 6 * _sy,
    _gw,
    _pole_y + 6 * _sy
);

// ====================================================
// TICKETS
// ====================================================
// Normal tickets drawn first.
// Selected ticket drawn last, on top.
//
// Preserve existing gui_x/gui_y animations.

for (var _pass = 0; _pass < 2; _pass++)
{
    for (var _i = 0; _i < array_length(tickets); _i++)
    {
        var _t = tickets[_i];

        var _active =
            (_t.ticket_id == selected_id
            && _t.status == "waiting");

        if ((_pass == 1) != _active) continue;

        var _prepared = (_t.status == "prepared");

        var _w = _active ? slot_selected_w : slot_normal_w;
        var _h = _active ? 78 : slot_h;

        var _px = _t.gui_x;
        var _py = _t.gui_y;

        if (_px > 645 || _px < -215) continue;

        var _x1 = round(_px * _sx);
        var _y1 = round(_py * _sy);
        var _x2 = round((_px + _w) * _sx);
        var _y2 = round((_py + _h) * _sy);

        // ====================================================
        // HOOKS / HANGERS
        // ====================================================
        // Two small iron loops attach each parchment ticket
        // to the wooden pole.
        //
        // Hooks follow the ticket's horizontal slide.

        var _hook_left = round((_px + 12) * _sx);
        var _hook_right = round((_px + _w - 12) * _sx);

        var _hook_top = round(269 * _sy);
        var _hook_bottom = max(
            _hook_top + 5 * _sy,
            _y1 + 4 * _sy
        );

        draw_set_color(_hook_dark);

        draw_line_width(
            _hook_left,
            _hook_top,
            _hook_left,
            _hook_bottom,
            max(2, 3 * _sx)
        );

        draw_line_width(
            _hook_right,
            _hook_top,
            _hook_right,
            _hook_bottom,
            max(2, 3 * _sx)
        );

        draw_set_color(_hook_light);

        draw_circle(
            _hook_left,
            _hook_top,
            max(2, 3 * _sx),
            false
        );

        draw_circle(
            _hook_right,
            _hook_top,
            max(2, 3 * _sx),
            false
        );

        // ====================================================
        // PARCHMENT SHADOW
        // ====================================================

        draw_set_alpha(0.35);
        draw_set_color(c_black);

        draw_rectangle(
            _x1 + 3 * _sx,
            _y1 + 4 * _sy,
            _x2 + 3 * _sx,
            _y2 + 4 * _sy,
            false
        );

        draw_set_alpha(1);

        // ====================================================
        // PARCHMENT BODY
        // ====================================================

        var _paper_color =
            _active
            ? make_color_rgb(242, 215, 160)
            : make_color_rgb(197, 169, 128);

        if (_prepared)
        {
            _paper_color = make_color_rgb(126, 123, 116);
        }

        draw_set_color(_paper_color);

        draw_rectangle(
            _x1,
            _y1,
            _x2,
            _y2,
            false
        );

        // Border.
        draw_set_color(
            _active
            ? _gold
            : make_color_rgb(105, 75, 49)
        );

        draw_rectangle(
            _x1,
            _y1,
            _x2,
            _y2,
            true
        );

        // Double border on selected ticket.
        if (_active)
        {
            draw_rectangle(
                _x1 + 2 * _sx,
                _y1 + 2 * _sy,
                _x2 - 2 * _sx,
                _y2 - 2 * _sy,
                true
            );
        }

        // Small metal fasteners at top.
        draw_set_color(_hook_dark);

        draw_circle(
            _hook_left,
            _y1 + 3 * _sy,
            max(1, 2 * _sx),
            false
        );

        draw_circle(
            _hook_right,
            _y1 + 3 * _sy,
            max(1, 2 * _sx),
            false
        );

        // ====================================================
        // TICKET NUMBER
        // ====================================================

        draw_set_font(Silkscreen10);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(_ink);

        draw_text(
            _x1 + 7 * _sx,
            _y1 + 5 * _sy,
            "#" + string(_t.ticket_id)
        );

        // ====================================================
        // FOOD SPRITE
        // ====================================================

        var _sp = _t.sprite;

        if (_sp != -1)
        {
            var _max = _active ? 40 : 32;

            var _scale = min(
                _max / max(1, sprite_get_width(_sp)),
                _max / max(1, sprite_get_height(_sp))
            );

            draw_sprite_ext(
                _sp,
                0,
                round((_px + 28) * _sx),
                round((_py + 42) * _sy),
                _scale * _sx,
                _scale * _sy,
                0,
                c_white,
                _prepared ? 0.45 : 1
            );
        }

        // ====================================================
        // FOOD NAME / TOPPING
        // ====================================================

        var _shortname =
            (_t.recipe == "bat_wings")
            ? "BAT WINGS"
            : "SKEWERED RAT";

        draw_set_color(_ink);
        draw_set_font(Silkscreen10);

        draw_text(
            round((_px + 52) * _sx),
            round((_py + 32) * _sy),
            _shortname
        );

        draw_text(
            round((_px + 52) * _sx),
            round((_py + 47) * _sy),
            _t.topping == ""
                ? "PLAIN"
                : "WITH RELISH"
        );

        // ====================================================
        // COMPLETED ORDER TICK
        // ====================================================

        if (_prepared)
        {
            draw_set_color(
                make_color_rgb(37, 105, 42)
            );

            var _check_x = (_px + _w / 2) * _sx;
            var _check_y = (_py + 20) * _sy;

            draw_line_width(
                _check_x - 12 * _sx,
                _check_y,
                _check_x - 3 * _sx,
                _check_y + 11 * _sy,
                4 * _sx
            );

            draw_line_width(
                _check_x - 3 * _sx,
                _check_y + 11 * _sy,
                _check_x + 17 * _sx,
                _check_y - 12 * _sy,
                4 * _sx
            );
        }
    }
}

// ====================================================
// TICKET LOCK MESSAGE
// ====================================================

if (locked_notice > 0)
{
    draw_set_color(
        make_color_rgb(255, 198, 123)
    );

    draw_set_halign(fa_center);
    draw_set_font(Silkscreen10);

    draw_text(
        _gw / 2,
        252 * _sy,
        "CLEAR PREP COUNTER FIRST!"
    );

    draw_set_halign(fa_left);
}

// ====================================================
// RESET DRAW STATE
// ====================================================

draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
