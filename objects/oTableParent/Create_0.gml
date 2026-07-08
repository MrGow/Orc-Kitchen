/// oTableParent — Create Event

station_name = "Table";

interactor = noone;

// Future shop/buy support.
// Bought/active tables should be available=true.
// Locked future tables can be placed in the room with available=false.
if (!variable_instance_exists(id, "available"))
{
    available = true;
}

// ----------------------------------------------------
// Table type / seats
// ----------------------------------------------------
table_type = "medium";
seat_count = 4;

// Detect child type
if (object_index == oTableSmall)
{
    table_type = "small";
    seat_count = 2;
}
else if (object_index == oTableMedium)
{
    table_type = "medium";
    seat_count = 4;
}
else if (object_index == oTableLarge)
{
    table_type = "large";
    seat_count = 6;
}

// ----------------------------------------------------
// Seat arrays
// ----------------------------------------------------
seat_customer = array_create(seat_count, noone);
seat_reserved = array_create(seat_count, false);

seat_xoff = array_create(seat_count, 0);
seat_yoff = array_create(seat_count, 0);

plate_xoff = array_create(seat_count, 0);
plate_yoff = array_create(seat_count, 0);

seat_has_food = array_create(seat_count, false);
seat_food_sprite = array_create(seat_count, -1);
seat_food_kind = array_create(seat_count, "");
seat_food_name = array_create(seat_count, "");
seat_food_data = array_create(seat_count, undefined);

seat_has_dirty_plate = array_create(seat_count, false);

// ----------------------------------------------------
// Seat positions
// Assumes table sprite origin = middle bottom.
// Top seats sit behind table.
// Bottom seats sit in front of table.
// ----------------------------------------------------
if (table_type == "small")
{
    // 2 seats: one top, one bottom
    seat_xoff[0] = 0;
    seat_yoff[0] = -112;
    plate_xoff[0] = 0;
    plate_yoff[0] = -70;

    seat_xoff[1] = 0;
    seat_yoff[1] = 24;
    plate_xoff[1] = 0;
    plate_yoff[1] = -26;
}
else if (table_type == "medium")
{
    // 4 seats: two top, two bottom
    seat_xoff[0] = -48;
    seat_yoff[0] = -112;
    plate_xoff[0] = -48;
    plate_yoff[0] = -70;

    seat_xoff[1] = 48;
    seat_yoff[1] = -112;
    plate_xoff[1] = 48;
    plate_yoff[1] = -70;

    seat_xoff[2] = -48;
    seat_yoff[2] = 24;
    plate_xoff[2] = -48;
    plate_yoff[2] = -26;

    seat_xoff[3] = 48;
    seat_yoff[3] = 24;
    plate_xoff[3] = 48;
    plate_yoff[3] = -26;
}
else if (table_type == "large")
{
    // 6 seats: three top, three bottom
    seat_xoff[0] = -80;
    seat_yoff[0] = -112;
    plate_xoff[0] = -80;
    plate_yoff[0] = -70;

    seat_xoff[1] = 0;
    seat_yoff[1] = -112;
    plate_xoff[1] = 0;
    plate_yoff[1] = -70;

    seat_xoff[2] = 80;
    seat_yoff[2] = -112;
    plate_xoff[2] = 80;
    plate_yoff[2] = -70;

    seat_xoff[3] = -80;
    seat_yoff[3] = 24;
    plate_xoff[3] = -80;
    plate_yoff[3] = -26;

    seat_xoff[4] = 0;
    seat_yoff[4] = 24;
    plate_xoff[4] = 0;
    plate_yoff[4] = -26;

    seat_xoff[5] = 80;
    seat_yoff[5] = 24;
    plate_xoff[5] = 80;
    plate_yoff[5] = -26;
}

// ----------------------------------------------------
// Payment values
// ----------------------------------------------------
pay_correct = 8;
pay_wrong = 2;
pay_burnt = 3;

// Depth sorting
depth = -y;