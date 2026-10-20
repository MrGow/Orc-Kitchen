/// oOSArcadeCabinet — Draw GUI

// ====================================================
// VISIBILITY
// ====================================================

if (room != Home)
{
    exit;
}

if (!global.arcade_owned)
{
    exit;
}

if (!player_near)
{
    exit;
}

if (global.paused)
{
    exit;
}


// ====================================================
// CAMERA CONVERSION
// ====================================================

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

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
// POSITION
// ====================================================

var _sx =
    (x - _cam_x) * (_gw / _cam_w);

var _sy =
    (bbox_top - _cam_y) * (_gh / _cam_h);

var _box_w = 194;
var _box_h = 30;

var _bx = clamp(
    _sx - _box_w * 0.5,
    8,
    max(8, _gw - _box_w - 8)
);

var _by = clamp(
    _sy - 39,
    8,
    max(8, _gh - _box_h - 8)
);


// ====================================================
// PROMPT TEXT
// ====================================================

var _message = "E - Play Orc Survivors";

if (variable_global_exists("evening_activity_used"))
{
    if (global.evening_activity_used)
    {
        _message = "Already Played Tonight";
    }
}


// ====================================================
// SHADOW
// ====================================================

draw_set_alpha(0.4);
draw_set_color(c_black);

draw_rectangle(
    _bx + 3,
    _by + 3,
    _bx + _box_w + 3,
    _by + _box_h + 3,
    false
);


// ====================================================
// PANEL
// ====================================================

draw_set_alpha(0.95);

draw_set_color(
    make_color_rgb(22, 18, 16)
);

draw_rectangle(
    _bx,
    _by,
    _bx + _box_w,
    _by + _box_h,
    false
);


// ====================================================
// BORDER
// ====================================================

draw_set_alpha(1);

draw_set_color(
    make_color_rgb(165, 115, 62)
);

draw_rectangle(
    _bx,
    _by,
    _bx + _box_w,
    _by + _box_h,
    true
);


// ====================================================
// TEXT
// ====================================================

var _font =
    asset_get_index("PixelifyRegular12");

draw_set_font(_font);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Shadow.
draw_set_color(c_black);

draw_text(
    _bx + _box_w * 0.5 + 1,
    _by + _box_h * 0.5 + 1,
    _message
);

// Main.
draw_set_color(c_white);

draw_text(
    _bx + _box_w * 0.5,
    _by + _box_h * 0.5,
    _message
);


// ====================================================
// RESTORE
// ====================================================

draw_set_alpha(1);
draw_set_color(c_white);

draw_set_font(-1);

draw_set_halign(fa_left);
draw_set_valign(fa_top);