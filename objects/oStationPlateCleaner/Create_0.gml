/// oStationPlateCleaner — Create Event

station_name = "Plate Cleaner";

interactor = noone;

// ----------------------------------------------------
// Queue / storage
// ----------------------------------------------------
dirty_queue = 0;
dirty_queue_max = 12;

clean_ready = 0;
clean_ready_max = 12;

// ----------------------------------------------------
// Washing
// ----------------------------------------------------
washing = false;
wash_progress = 0;
wash_time = room_speed * 2; // 2 seconds per plate

// Draw offsets
plate_draw_xoff = 0;
plate_draw_yoff = -28;

// Depth sorting
depth = -y;