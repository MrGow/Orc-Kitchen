/// oStationPrepCounter — Create Event

station_name = "Prep Counter";

interactor = noone;

// Container / plate
has_plate = false;
plate_kind = "";
plate_sprite = -1;
plate_name = "";
plate_data = undefined;

// Component on the plate/counter
has_component = false;
component_kind = "";
component_sprite = -1;
component_name = "";
component_data = undefined;
component_bob = random(1000);

// Finished meal
finished = false;
finished_kind = "";
finished_sprite = -1;
finished_name = "";
finished_data = undefined;

// Draw positions
plate_draw_xoff = 0;
plate_draw_yoff = -34;

component_draw_xoff = 18;
component_draw_yoff = -38;

finished_draw_xoff = 0;
finished_draw_yoff = -36;

// Prevent instant pickup on same press after completing
finish_lock_timer = 0;

// Depth sorting
depth = -y;