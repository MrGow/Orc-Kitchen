/// oStationPlateCleaner — Step Event

depth = -y;

// Handle washing timer
if (washing)
{
    wash_progress += 1;

    if (wash_progress >= wash_time)
    {
        washing = false;
        wash_progress = 0;
        clean_plate_ready = true;
    }
}