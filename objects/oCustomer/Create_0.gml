/// oCustomer — Create Event

sprite_index = spriteMainOrcIdle;
image_speed = 0.12;

// ----------------------------------------------------
// Movement / state
// ----------------------------------------------------
state = "walking_to_table";

move_spd = 1.25;

target_table = noone;
target_seat = -1;

sit_x = x;
sit_y = y;

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
leave_timer = 0;

reaction_text = "";
reaction_timer = 0;

pay_amount = 0;

// Depth sorting
depth = -y;