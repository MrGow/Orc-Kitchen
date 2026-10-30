/// oOrderTicketController — Create (FULL EVENT)
/// Place ONE instance in MessHall, no sprite.

if (instance_number(oOrderTicketController) > 1) { instance_destroy(); exit; }

tickets = [];
next_number = 1;
selected_id = -1;
slide_speed = 0.22;
ticket_max_visible = 4;
locked_notice = 0;
controller_frame = 0;

// Ticket positions are in 640 x 360 GUI coordinates.
rail_y = 278;
slot_first_x = 8;
slot_gap = 6;
slot_normal_w = 132;
slot_selected_w = 177;
slot_h = 70;

// Publish selected ticket via this instance, not global struct copies.
global.order_ticket_controller = id;
