/// oCustomerSpawner — Create Event
// The day's total and individual arrival times come from oGame.

// Number of arrivals already created during the current day.
spawned_count = 0;

// If a scheduled spawn is blocked by full tables + queue,
// retry periodically without discarding that customer.
retry_timer = 0;
retry_delay = max(1, round(room_speed * 0.5));

// Avoid more than one new customer every 0.5 seconds,
// even when multiple schedules have become overdue.
spawn_cooldown = 0;
spawn_cooldown_length = max(1, round(room_speed * 0.5));

debug_spawner = true;
depth = 100000;

show_debug_message("[CustomerSpawner] Created. Waiting for serving.");
