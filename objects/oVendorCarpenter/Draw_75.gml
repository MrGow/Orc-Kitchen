/// oVendorCarpenter — Draw GUI End Event

// ====================================================
// VISIBILITY
// ====================================================

if (!shop_open || room != Market)
{
    exit;
}


// ====================================================
// GUI DIMENSIONS
// ====================================================

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

var _cx = _gw * 0.5;


// ====================================================
// PANEL DIMENSIONS
// ====================================================

var _pw = min(430, _gw - 16);
var _ph = min(340, _gh - 12);

var _px = (_gw - _pw) * 0.5;
var _py = (_gh - _ph) * 0.5;


// ====================================================
// COLOURS
// ====================================================

var _wood = make_color_rgb(49, 34, 24);
var _border = make_color_rgb(171, 119, 61);
var _paper = make_color_rgb(233, 210, 162);

var _highlight = make_color_rgb(106, 71, 42);


// ====================================================
// BACKDROP
// ====================================================

draw_set_alpha(0.82);
draw_set_color(c_black);

draw_rectangle(
    0, 0, _gw, _gh, false
);


// ====================================================
// WOODEN BOARD
// ====================================================

draw_set_alpha(1);
draw_set_color(_wood);

draw_rectangle(
    _px,
    _py,
    _px + _pw,
    _py + _ph,
    false
);

draw_set_color(_border);

draw_rectangle(
    _px,
    _py,
    _px + _pw,
    _py + _ph,
    true
);


// ====================================================
// HEADER
// ====================================================

draw_set_halign(fa_center);
draw_set_valign(fa_top);

draw_set_color(c_yellow);

draw_text(
    _cx,
    _py + 12,
    vendor_name
);

draw_set_color(_paper);

draw_text(
    _cx,
    _py + 33,
    "'Fine wood. Questionable workmanship.'"
);

draw_text(
    _cx,
    _py + 54,
    "YOUR GOLD: " + string(global.gold)
);


// ====================================================
// SHOP ITEM LIST
// ====================================================

var _item_count = array_length(shop_items);

var _row_start = _py + 84;
var _row_spacing = 34;

for (var i = 0; i < _item_count; i++)
{
    var _item = shop_items[i];

    var _yy = _row_start + i * _row_spacing;

    var _owned = false;
    var _cost = 0;


    // ------------------------------------------------
    // TABLE ITEM
    // ------------------------------------------------

    if (_item.kind == "table")
    {
        var _id = _item.table_id;

        if (variable_global_exists("tables_owned"))
        {
            if (_id >= 0
                && _id < array_length(global.tables_owned))
            {
                _owned = global.tables_owned[_id];
            }
        }

        if (variable_global_exists("table_prices"))
        {
            if (_id >= 0
                && _id < array_length(global.table_prices))
            {
                _cost = global.table_prices[_id];
            }
        }
    }


    // ------------------------------------------------
    // ARCADE ITEM
    // ------------------------------------------------

    else if (_item.kind == "arcade")
    {
        _owned = global.arcade_owned;
        _cost = arcade_price;
    }


    // ------------------------------------------------
    // SELECTED ROW BACKGROUND
    // ------------------------------------------------

    if (selected == i)
    {
        draw_set_color(_highlight);

        draw_rectangle(
            _px + 14,
            _yy - 4,
            _px + _pw - 14,
            _yy + 26,
            false
        );
    }


    // ------------------------------------------------
    // ITEM NAME
    // ------------------------------------------------

    draw_set_halign(fa_left);

    draw_set_color(
        selected == i ? c_yellow : _paper
    );

    draw_text(
        _px + 29,
        _yy,
        _item.name
    );


    // ------------------------------------------------
    // PRICE / OWNERSHIP
    // ------------------------------------------------

    draw_set_halign(fa_right);

    draw_set_color(
        _owned ? c_lime : _paper
    );

    var _price_text = _owned
        ? "OWNED"
        : string(_cost) + " G";

    draw_text(
        _px + _pw - 29,
        _yy,
        _price_text
    );
}


// ====================================================
// FEEDBACK
// ====================================================

draw_set_halign(fa_center);

var _feedback_y = _py + _ph - 57;

if (feedback_timer > 0)
{
    draw_set_color(c_yellow);

    draw_text(
        _cx,
        _feedback_y,
        feedback_text
    );
}


// ====================================================
// FOOTER
// ====================================================

draw_set_color(_paper);

draw_text(
    _cx,
    _py + _ph - 26,
    "UP/DOWN: SELECT   E/ENTER: BUY   ESC: CLOSE"
);


// ====================================================
// RESTORE DRAW STATE
// ====================================================

draw_set_font(-1);

draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_set_alpha(1);
draw_set_color(c_white);