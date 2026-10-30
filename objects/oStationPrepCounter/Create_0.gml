/// oStationPrepCounter — Create (FULL EVENT)
station_name = "Prep Counter";
interactor = noone;

has_plate = false;
plate_kind = "";
plate_sprite = -1;
plate_name = "";
plate_data = undefined;

has_component = false;
component_kind = "";
component_sprite = -1;
component_name = "";
component_data = undefined;
component_bob = random(1000);

finished = false;
finished_kind = "";
finished_sprite = -1;
finished_name = "";
finished_data = undefined;

plate_draw_xoff = -18;
plate_draw_yoff = -34;
component_draw_xoff = 22;
component_draw_yoff = -38;
finished_draw_xoff = 0;
finished_draw_yoff = -36;
finish_lock_timer = 0;

// Set when first ingredient is placed. Remains assigned until
// dish finishes or player completely empties the counter.
assigned_ticket_id = -1;
assigned_recipe = "";
depth = -y;
