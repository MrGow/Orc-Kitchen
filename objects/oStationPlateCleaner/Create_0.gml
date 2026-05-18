/// oStationPlateCleaner — Create Event

station_name = "Plate Cleaner";

interactor = noone;

washing = false;
wash_progress = 0;
wash_time = room_speed * 2; // 2 seconds

clean_plate_ready = false;

// Draw offsets
plate_draw_xoff = 0;
plate_draw_yoff = -28;

// Depth sorting
depth = -y;