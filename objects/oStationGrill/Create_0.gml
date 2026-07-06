/// oStationGrill — Create Event

station_name = "Grill";

interactor = noone;

// One-slot grill for now
has_food = false;

food_kind = "";
food_sprite = -1;
food_name = "";
food_data = undefined;

// Cooking timer
cook_timer = 0;

// At 2 seconds, rat becomes cooked.
// At 5 seconds, rat becomes burnt.
cook_time_cooked = room_speed * 2;
cook_time_burnt  = room_speed * 5;

cook_state = ""; // "", "raw", "cooked", "burnt"

// Food draw offset on grill
food_draw_xoff = 0;
food_draw_yoff = -34;

// Depth sorting
depth = -y;