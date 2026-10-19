/// oSocialNPC — Draw GUI
// ====================================================
// SOCIAL DIALOGUE PRESENTATION
//
// - NPC-relative dialogue positioning
// - Camera-to-GUI coordinate conversion
// - Automatic dialogue sizing
// - Correct line spacing
// - Text and panel shadows
// - Relationship ranks and choices
// - Cinematic letterbox safe area
// ====================================================


// ====================================================
// VISIBILITY
// ====================================================

if (dialogue_mode == "idle" && !player_near)
{
    exit;
}

if (dialogue_mode != "idle")
{
    if (global.social_active != id)
    {
        exit;
    }
}


// ====================================================
// GUI DIMENSIONS
// ====================================================

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();


// ====================================================
// CAMERA COORDINATES
// ====================================================

var _cam = view_camera[0];

var _cam_x = 0;
var _cam_y = 0;

var _cam_w = room_width;
var _cam_h = room_height;

if (_cam != -1)
{
    _cam_x = camera_get_view_x(_cam);
    _cam_y = camera_get_view_y(_cam);

    _cam_w = camera_get_view_width(_cam);
    _cam_h = camera_get_view_height(_cam);
}

_cam_w = max(1, _cam_w);
_cam_h = max(1, _cam_h);


// ====================================================
// NPC WORLD POSITION -> GUI POSITION
// ====================================================

var _screen_x =
    (x - _cam_x) * (_gw / _cam_w);

var _screen_y =
    (y - npc_height - _cam_y)
    * (_gh / _cam_h);


// ====================================================
// CINEMATIC SAFE AREA
// ====================================================

// Normal conversations use the whole screen.
//
// During social events, cinematic bars reduce
// the available vertical space.

var _bar_height = 0;

if (variable_global_exists("social_cine_bar_height"))
{
    _bar_height =
        global.social_cine_bar_height;
}

// The cinematic controller publishes a height
// in reference 640x360 GUI pixels.
_bar_height *= (_gh / 360);

_bar_height = clamp(
    _bar_height,
    0,
    floor(_gh * 0.25)
);

var _margin = 8;

var _safe_top =
    _bar_height + _margin;

var _safe_bottom =
    _gh - _bar_height - _margin;


// ====================================================
// FONTS
// ====================================================

var _body_font =
    asset_get_index("PixelifyRegular12");

var _header_font =
    asset_get_index("PixelifyBold14");

if (_body_font == -1)
{
    _body_font = -1;
}

if (_header_font == -1)
{
    _header_font = _body_font;
}


// ====================================================
// INTERACTION PROMPT
// ====================================================

if (dialogue_mode == "idle")
{
    var _prompt_w = 100;
    var _prompt_h = 25;

    var _px = clamp(
        _screen_x - _prompt_w * 0.5,
        _margin,
        max(
            _margin,
            _gw - _prompt_w - _margin
        )
    );

    var _py = clamp(
        _screen_y - 38,
        _safe_top,
        max(
            _safe_top,
            _safe_bottom - _prompt_h
        )
    );


    // ------------------------------------------------
    // SHADOW
    // ------------------------------------------------

    draw_set_alpha(0.35);
    draw_set_color(c_black);

    draw_rectangle(
        _px + 3,
        _py + 3,
        _px + _prompt_w + 3,
        _py + _prompt_h + 3,
        false
    );


    // ------------------------------------------------
    // BACKGROUND
    // ------------------------------------------------

    draw_set_alpha(0.94);

    draw_set_color(
        make_color_rgb(24, 19, 16)
    );

    draw_rectangle(
        _px,
        _py,
        _px + _prompt_w,
        _py + _prompt_h,
        false
    );


    // ------------------------------------------------
    // BORDER
    // ------------------------------------------------

    draw_set_alpha(1);

    draw_set_color(
        make_color_rgb(165, 115, 62)
    );

    draw_rectangle(
        _px,
        _py,
        _px + _prompt_w,
        _py + _prompt_h,
        true
    );


    // ------------------------------------------------
    // PROMPT TEXT
    // ------------------------------------------------

    draw_set_font(_body_font);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_set_color(c_black);

    draw_text(
        _px + _prompt_w * 0.5 + 1,
        _py + _prompt_h * 0.5 + 1,
        "E - Talk"
    );

    draw_set_color(c_white);

    draw_text(
        _px + _prompt_w * 0.5,
        _py + _prompt_h * 0.5,
        "E - Talk"
    );


    // ------------------------------------------------
    // RESTORE DRAW STATE
    // ------------------------------------------------

    draw_set_alpha(1);
    draw_set_color(c_white);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    draw_set_font(-1);

    exit;
}


// ====================================================
// RELATIONSHIP RANK
// ====================================================

var _rank = variable_struct_get(
    global.social_ranks,
    social_key
);


// ====================================================
// DETERMINE BODY TEXT
// ====================================================

var _body_text = "";

if (dialogue_mode == "choice")
{
    if (_rank < array_length(episodes))
    {
        var _ep = episodes[_rank];

        _body_text =
            "Spend the evening with "
            + npc_name
            + "?\n"
            + _ep.title
            + "\nReward: "
            + _ep.reward_text;
    }
    else
    {
        _body_text = "No event available.";
    }
}
else
{
    if (dialogue_index < array_length(dialogue_lines))
    {
        _body_text =
            dialogue_lines[dialogue_index];
    }
}


// ====================================================
// TEXT MEASUREMENT
// ====================================================

var _box_w = min(
    330,
    _gw - _margin * 2
);

var _padding = 12;

var _text_w =
    _box_w - _padding * 2;

// -1 uses font-defined line spacing.
var _line_sep = -1;

draw_set_font(_body_font);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _body_h = string_height_ext(
    _body_text,
    _line_sep,
    _text_w
);


// ====================================================
// PANEL HEIGHT
// ====================================================

var _header_h = 37;
var _footer_h = 27;

var _choice_h = 0;

if (dialogue_mode == "choice")
{
    _choice_h = 45;
}

var _box_h =
    _header_h
    + _body_h
    + _footer_h
    + _choice_h
    + 10;

_box_h = max(
    86,
    _box_h
);


// ====================================================
// RESPECT CINEMATIC SAFE AREA
// ====================================================

var _available_h =
    max(1, _safe_bottom - _safe_top);

// A dialogue entry should normally fit.
//
// For extremely long entries, we constrain the panel
// and clip text to its interior, rather than allowing
// the panel to cover the cinematic bars.

_box_h = min(
    _box_h,
    _available_h
);


// ====================================================
// PANEL POSITION
// ====================================================

var _left = clamp(
    _screen_x - _box_w * 0.5,
    _margin,
    max(
        _margin,
        _gw - _box_w - _margin
    )
);

// Prefer above the NPC.
var _top =
    _screen_y - _box_h - 12;

// If insufficient room above, try below.
if (_top < _safe_top)
{
    _top = _screen_y + npc_height + 10;
}

// Ensure panel stays within cinematic safe area.
_top = clamp(
    _top,
    _safe_top,
    max(
        _safe_top,
        _safe_bottom - _box_h
    )
);

var _right =
    _left + _box_w;

var _bottom =
    _top + _box_h;


// ====================================================
// SHADOW
// ====================================================

draw_set_alpha(0.42);
draw_set_color(c_black);

draw_rectangle(
    _left + 3,
    _top + 4,
    min(_gw - _margin, _right + 3),
    min(_safe_bottom, _bottom + 4),
    false
);


// ====================================================
// PANEL BACKGROUND
// ====================================================

draw_set_alpha(0.96);

draw_set_color(
    make_color_rgb(22, 18, 16)
);

draw_rectangle(
    _left,
    _top,
    _right,
    _bottom,
    false
);


// ====================================================
// PANEL BORDER
// ====================================================

draw_set_alpha(1);

draw_set_color(
    make_color_rgb(165, 115, 62)
);

draw_rectangle(
    _left,
    _top,
    _right,
    _bottom,
    true
);


// ====================================================
// NPC NAME
// ====================================================

draw_set_font(_header_font);

draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Shadow.
draw_set_color(c_black);

draw_text(
    _left + _padding + 1,
    _top + 10,
    npc_name
);

// Main text.
draw_set_color(
    make_color_rgb(235, 195, 123)
);

draw_text(
    _left + _padding,
    _top + 9,
    npc_name
);


// ====================================================
// RANK INDICATOR
// ====================================================

draw_set_font(_body_font);

draw_set_halign(fa_right);

var _rank_text =
    string(_rank)
    + "/"
    + string(max_rank);

// Shadow.
draw_set_color(c_black);

draw_text(
    _right - _padding + 1,
    _top + 11,
    _rank_text
);

// Main text.
draw_set_color(c_white);

draw_text(
    _right - _padding,
    _top + 10,
    _rank_text
);


// ====================================================
// HEADER DIVIDER
// ====================================================

draw_set_color(
    make_color_rgb(90, 69, 49)
);

draw_line(
    _left + _padding,
    _top + 31,
    _right - _padding,
    _top + 31
);


// ====================================================
// BODY TEXT
// ====================================================

draw_set_font(_body_font);

draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _text_x =
    _left + _padding;

var _text_y =
    _top + _header_h;

// Available content space before choices/footer.
var _reserved_h =
    _footer_h
    + _choice_h
    + 10;

var _body_limit =
    _bottom - _reserved_h;

// We use a GPU scissor rectangle for unusually
// long text so it cannot cover the bars or footer.

var _clip_top = max(
    _safe_top,
    _text_y
);

var _clip_bottom = max(
    _clip_top,
    _body_limit
);

var _clip_left = max(0, _text_x - 2);
var _clip_right = min(_gw, _right - _padding + 2);

// GUI Draw normally uses the application viewport.
// Avoid altering clipping unless the text truly
// exceeds its allotted panel space.

if (_body_h <= _clip_bottom - _clip_top)
{
    // Text shadow.
    draw_set_color(c_black);

    draw_text_ext(
        _text_x + 1,
        _text_y + 1,
        _body_text,
        _line_sep,
        _text_w
    );

    // Main text.
    draw_set_color(
        make_color_rgb(243, 234, 215)
    );

    draw_text_ext(
        _text_x,
        _text_y,
        _body_text,
        _line_sep,
        _text_w
    );
}
else
{
    // Exceptionally long dialogue entry.
    // Show a short safe portion instead of
    // overflowing the cinematic region.

    draw_set_color(
        make_color_rgb(243, 234, 215)
    );

    var _short_text =
        string_copy(_body_text, 1, 110);

    draw_text_ext(
        _text_x,
        _text_y,
        _short_text,
        _line_sep,
        _text_w
    );
}


// ====================================================
// CHOICE MENU
// ====================================================

if (dialogue_mode == "choice")
{
    var _choice_y =
        _bottom - _footer_h - 45;

    draw_set_font(_body_font);
    draw_set_halign(fa_left);

    // Spend Evening.
    if (choice_selected == 0)
    {
        draw_set_color(
            make_color_rgb(245, 207, 115)
        );

        draw_text(
            _text_x,
            _choice_y,
            "> Spend Evening"
        );
    }
    else
    {
        draw_set_color(c_white);

        draw_text(
            _text_x,
            _choice_y,
            "  Spend Evening"
        );
    }

    // Not Now.
    if (choice_selected == 1)
    {
        draw_set_color(
            make_color_rgb(245, 207, 115)
        );

        draw_text(
            _text_x,
            _choice_y + 20,
            "> Not Now"
        );
    }
    else
    {
        draw_set_color(c_white);

        draw_text(
            _text_x,
            _choice_y + 20,
            "  Not Now"
        );
    }
}


// ====================================================
// FOOTER INSTRUCTIONS
// ====================================================

draw_set_font(_body_font);

draw_set_halign(fa_right);
draw_set_valign(fa_top);

draw_set_color(
    make_color_rgb(195, 165, 116)
);

var _hint = "E / SPACE >";

if (dialogue_mode == "choice")
{
    _hint = "UP / DOWN - E";
}

draw_text(
    _right - _padding,
    _bottom - 21,
    _hint
);


// ====================================================
// RESTORE DRAW STATE
// ====================================================

draw_set_alpha(1);
draw_set_color(c_white);

draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_set_font(-1);