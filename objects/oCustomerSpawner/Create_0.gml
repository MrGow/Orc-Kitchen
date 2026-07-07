/// oCustomerSpawner — Create Event

spawn_delay = room_speed * 5;
spawn_timer = spawn_delay;

// For testing, let it spawn several customers over time.
max_spawned_for_test = 6;
spawned_count = 0;

// Debug
debug_spawner = true;

// This object should not visually matter.
depth = 100000;

show_debug_message("[CustomerSpawner] Created.");