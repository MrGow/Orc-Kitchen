/// oStationPrepCounter — Create Event

station_name = "Prep Counter";

interactor = noone;

// Whether this counter currently has a plate on it
has_plate = false;
plate_kind = "";
plate_sprite = -1;
plate_name = "";
plate_data = undefined;

// Draw position of plate on the counter.
// Adjust after seeing your sprite.
plate_draw_xoff = 0;
plate_draw_yoff = -34;

// Depth sorting
depth = -y;