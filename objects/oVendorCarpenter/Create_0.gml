/// oVendorCarpenter — Create Event
// Assign a temporary rectangle sprite, then replace it with
// the carpenter's woodcutting animation later.

vendor_name = "GRUK'S CARPENTRY";
interaction_range = 70;
shop_open = false;
selected = 0;
feedback_text = "";
feedback_timer = 0;

// IDs 1–4 match the four purchasable tables in MessHall.
shop_table_ids = [1, 2, 3, 4];
shop_table_names = [
    "Medium Table I",
    "Medium Table II",
    "Large Table I",
    "Large Table II"
];

// Let a future animated sprite play continuously.
image_speed = 0.12;
depth = -y;
