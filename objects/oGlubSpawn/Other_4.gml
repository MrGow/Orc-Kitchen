/// oGlubSpawn — Room Start
if (room != Market && room != CentralPlaza) exit;

scr_glub_roll_daily();

if (spawn_id != global.glub_spawn_id) exit;
if (instance_exists(oGlubVendor)) exit;

// Glub is room-local. Changing rooms destroys him;
// matching marker recreates him at the SAME place on re-entry.
instance_create_depth(x, y, -y, oGlubVendor);
