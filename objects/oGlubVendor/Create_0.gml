/// oGlubVendor — Create
vendor_name = "GLUB'S AQUATIC VIOLENCE";
interaction_range = 65;
shop_open = false;
selected = 0;
feedback_text = "";
feedback_timer = 0;
player_near = false;

// Key/price/label are permanent shop definitions, NOT individual card instances.
shop_items = [
    { key: "lick_wounds", name: "LICK YER WOUNDS", price: 12, desc: "HEAL 12 HP  |  2 USES" },
    { key: "iron_gut",    name: "IRON GUT",       price: 25, desc: "BLOCK NEXT HIT  |  2 USES" },
    { key: "electric_slap",name:"ELECTRIC SLAP",price: 45, desc: "MAGIC HIT; CHANCE TO STUN" },
    { key: "fish_execution",name:"FISH EXECUTION",price:80,desc: "BRUTAL FINISHER  |  1 USE" }
];

if (!variable_global_exists("fishing_owned_cards"))
    global.fishing_owned_cards = ["punch", "big_punch", "defend"];

image_speed = 0.12;
solid = false;
depth = -y;
