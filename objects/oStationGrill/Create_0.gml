/// oStationGrill — Create Event

station_name = "Grill";

interactor = noone;

has_food = false;

food_kind = "";
food_sprite = -1;
food_name = "";
food_data = undefined;

cook_timer = 0;

cook_time_cooked = room_speed * 2;
cook_time_burnt  = room_speed * 5;

cook_state = ""; // "", "raw", "cooked", "burnt"

food_draw_xoff = 0;
food_draw_yoff = -34;

depth = -y;