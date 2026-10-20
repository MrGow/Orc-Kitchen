/// oVendorCarpenter — Create Event

// ====================================================
// VENDOR SETTINGS
// ====================================================

vendor_name = "GRUK'S CARPENTRY";

interaction_range = 70;

shop_open = false;

selected = 0;

feedback_text = "";
feedback_timer = 0;


// ====================================================
// TABLES
// ====================================================

// IDs 1–4 match the four purchasable tables
// already placed in the Mess Hall.

shop_table_ids = [1, 2, 3, 4];

shop_table_names = [
    "Medium Table I",
    "Medium Table II",
    "Large Table I",
    "Large Table II"
];


// ====================================================
// ARCADE CABINET
// ====================================================

arcade_name = "Orc Survivors Arcade";
arcade_price = 1;

// Initialise only when missing.
// Ownership must survive room changes.

if (!variable_global_exists("arcade_owned"))
{
    global.arcade_owned = false;
}


// ====================================================
// SHOP ITEMS
// ====================================================

// Each entry identifies which item it represents.

shop_items = [
    { kind: "table", table_id: 1, name: shop_table_names[0] },
    { kind: "table", table_id: 2, name: shop_table_names[1] },
    { kind: "table", table_id: 3, name: shop_table_names[2] },
    { kind: "table", table_id: 4, name: shop_table_names[3] },
    { kind: "arcade", table_id: -1, name: arcade_name }
];


// ====================================================
// APPEARANCE
// ====================================================

image_speed = 0.12;

depth = -y;