/// oCustomerQueueSpot — Create Event

slot_count = 6;

queue_customer = array_create(slot_count, noone);

slot_xoff = array_create(slot_count, 0);
slot_yoff = array_create(slot_count, 0);

// Vertical queue line.
// Move the object in the room to position the first slot.
for (var i = 0; i < slot_count; i++)
{
    slot_xoff[i] = 0;
    slot_yoff[i] = i * 30;
}

depth = -y;