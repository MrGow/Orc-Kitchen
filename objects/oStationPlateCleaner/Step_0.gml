/// oStationPlateCleaner — Step Event

if (global.paused) exit;

depth = -y;

// ----------------------------------------------------
// Start washing if possible
// ----------------------------------------------------
if (!washing)
{
    if (dirty_queue > 0 && clean_ready < clean_ready_max)
    {
        washing = true;
        wash_progress = 0;
        dirty_queue -= 1;
    }
}

// ----------------------------------------------------
// Handle washing timer
// ----------------------------------------------------
if (washing)
{
    wash_progress += 1;

    if (wash_progress >= wash_time)
    {
        washing = false;
        wash_progress = 0;

        if (clean_ready < clean_ready_max)
        {
            clean_ready += 1;
        }
    }
}