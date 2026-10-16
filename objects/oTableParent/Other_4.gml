/// oTableParent — Room Start Event

// ====================================================
// TABLE OWNERSHIP / UNLOCK SYSTEM
// ====================================================

// Only apply ownership rules in MessHall.
if (room != MessHall)
{
    exit;
}

// ----------------------------------------------------
// Check ownership system exists
// ----------------------------------------------------
if (!variable_global_exists("tables_owned"))
{
    show_debug_message(
        "[Table] WARNING: global.tables_owned is missing."
    );

    exit;
}

// ----------------------------------------------------
// Check table has a configured ID
// ----------------------------------------------------
if (!variable_instance_exists(id, "table_id"))
{
    show_debug_message(
        "[Table] WARNING: No table_id configured at "
        + string(x)
        + ", "
        + string(y)
    );

    // Keep visible for easier debugging.
    exit;
}

// ----------------------------------------------------
// Validate ID
// ----------------------------------------------------
if (table_id < 0 || table_id >= array_length(global.tables_owned))
{
    show_debug_message(
        "[Table] WARNING: Invalid table_id "
        + string(table_id)
    );

    exit;
}

// ----------------------------------------------------
// Check whether this table has been purchased
// ----------------------------------------------------
available = global.tables_owned[table_id];

if (!available)
{
    // Completely remove locked tables.
    // This also removes their collision and seat positions.
    //
    // Room instances will be recreated the next time
    // MessHall is entered.

    if (global.ok_debug)
    {
        show_debug_message(
            "[Table] Locked table "
            + string(table_id)
            + " removed."
        );
    }

    instance_destroy();
    exit;
}

// ----------------------------------------------------
// Owned table remains active
// ----------------------------------------------------
visible = true;
available = true;

if (global.ok_debug)
{
    show_debug_message(
        "[Table] Active owned table ID "
        + string(table_id)
        + " ("
        + table_type
        + ")"
    );
}