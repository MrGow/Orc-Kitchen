/// oMessHallExit — Draw GUI

// ====================================================
// BLOCKED MESSAGE
// ====================================================

if (exit_text_timer <= 0) exit;

// Convert world position to GUI position.
// This accounts for the active camera.

var _cam = view_camera[0];

var _cam_x = camera_get_view_x(_cam);
var _cam_y = camera_get_view_y(_cam);

var _cam_w = camera_get_view_width(_cam);
var _cam_h = camera_get_view_height(_cam);

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

var _scale_x = _gui_w / _cam_w;
var _scale_y = _gui_h / _cam_h;

// Position above the exit.
var _world_x = (bbox_left + bbox_right) * 0.5;
var _world_y = bbox_top - 42;

var _tx = (_world_x - _cam_x) * _scale_x;
var _ty = (_world_y - _cam_y) * _scale_y;


// ====================================================
// MESSAGE BACKGROUND
// ====================================================

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_color(c_black);
draw_set_alpha(0.80);

draw_roundrect(
    _tx - 110,
    _ty - 14,
    _tx + 110,
    _ty + 14,
    false
);


// ====================================================
// MESSAGE TEXT
// ====================================================

draw_set_alpha(1);
draw_set_color(c_white);

draw_text(
    _tx,
    _ty,
    exit_text
);


// ====================================================
// RESET DRAW STATE
// ====================================================

draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_set_color(c_white);
draw_set_alpha(1);