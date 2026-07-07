/// oStationPrepCounter — Step Event

if (global.paused) exit;

depth = -y;

if (finish_lock_timer > 0)
{
    finish_lock_timer -= 1;
}