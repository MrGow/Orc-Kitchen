/// oCamera — Draw GUI Event

if (!debug_camera) exit;

draw_set_color(c_white);
draw_text(16, 16, "Camera: " + string(global.cam_x) + ", " + string(global.cam_y));
draw_text(16, 32, "Room: " + string(room_width) + " x " + string(room_height));
draw_text(16, 48, "View: " + string(cam_w) + " x " + string(cam_h));