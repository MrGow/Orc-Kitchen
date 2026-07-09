/// oCustomer — Create Event

sprite_index = spriteMainOrcWalk;
image_speed = 0.12;

// ----------------------------------------------------
// Movement / state
// ----------------------------------------------------
state = "walking_to_table";

move_spd = 1.25;

// Small collision footprint, similar to player.
feet_half_w = 9;
feet_half_h = 6;

target_table = noone;
target_seat = -1;

sit_x = x;
sit_y = y;

// Queue
target_queue = noone;
queue_index = -1;
queue_x = x;
queue_y = y;

// Spawn/exit
spawn_x = x;
spawn_y = y;

// ----------------------------------------------------
// Simple waypoint route
// ----------------------------------------------------
route_points = [];
route_index = 0;

// If a route gets stuck, we flip which side of the table we try to use.
route_side_flip = false;

// Used to detect if customer is stuck.
stuck_timer = 0;
last_x = x;
last_y = y;

// ----------------------------------------------------
// Order
// For now, every customer wants correctly cooked Skewered Rat.
// ----------------------------------------------------
order_kind = "meal_skewered_rat";
order_recipe = "skewered_rat";
order_cook_state = "cooked";
order_name = "Skewered Rat";
order_sprite = spriteFoodFinalSkeweredRat;

// ----------------------------------------------------
// Served food
// ----------------------------------------------------
served_kind = "";
served_name = "";
served_data = undefined;

served_table = noone;
served_seat = -1;

// ----------------------------------------------------
// Timers / mood
// ----------------------------------------------------
patience = room_speed * 45;
satisfaction = 100;

eat_timer = 0;

reaction_text = "";
reaction_timer = 0;

pay_amount = 0;

// Prevent active_customers decrementing twice.
has_left_counted = false;

// Depth sorting
depth = -y;