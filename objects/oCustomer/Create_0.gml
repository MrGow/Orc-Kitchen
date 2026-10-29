/// oCustomer — Create (FULL REPLACEMENT)

sprite_index = spriteChefRunDownwards;
image_speed = 0.12;
image_xscale = 1;
image_yscale = 1;

// Same small consistent feet hitbox as the Chef.
// Sprite stays invisible; only its collision shape is used.
mask_index = spriteChefCollision;

state = "walking_to_table";
move_spd = 1.25;
feet_half_w = 9;
feet_half_h = 6;

target_table = noone;
target_seat = -1;
sit_x = x;
sit_y = y;
seat_approach_x = x;
seat_approach_y = y;

target_queue = noone;
queue_index = -1;
queue_x = x;
queue_y = y;
spawn_x = x;
spawn_y = y;

route_points = [];
route_index = 0;
route_side_flip = false;
stuck_timer = 0;
last_x = x;
last_y = y;

order_kind = "meal_skewered_rat";
order_recipe = "skewered_rat";
order_cook_state = "cooked";
order_name = "Skewered Rat";
order_sprite = spriteFoodFinalSkeweredRat;

served_kind = "";
served_name = "";
served_data = undefined;
served_table = noone;
served_seat = -1;

patience = room_speed * 45;
satisfaction = 100;
eat_timer = 0;
reaction_text = "";
reaction_timer = 0;
pay_amount = 0;
has_left_counted = false;
depth = -y;
