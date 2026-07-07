/// oStationGobbleToad — Create Event

station_name = "Gobble-Toad";

interactor = noone;

// ----------------------------------------------------
// Gobble feedback
// ----------------------------------------------------
gobble_timer = 0;
gobble_text = "";
gobble_text_timer = 0;

// Tiny animation squash/pop
base_xscale = image_xscale;
base_yscale = image_yscale;

// Counts for debugging / future stats
food_eaten = 0;
waste_value = 0;

// Depth sorting
depth = -y;