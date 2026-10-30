/// oVendorCarpenter — Draw GUI End
/// Silkscreen shop UI with crisp one-pixel dark text shadow.

if (!shop_open || room != Market) exit;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _cx = _gw * 0.5;

var _pw = min(430, _gw - 16);
var _ph = min(340, _gh - 12);
var _px = (_gw - _pw) * 0.5;
var _py = (_gh - _ph) * 0.5;

var _wood = make_color_rgb(49, 34, 24);
var _border = make_color_rgb(171, 119, 61);
var _paper = make_color_rgb(243, 225, 188);
var _muted = make_color_rgb(215, 190, 151);
var _gold = make_color_rgb(250, 208, 104);
var _highlight = make_color_rgb(106, 71, 42);
var _shadow = make_color_rgb(20, 12, 10);

// Draw text with a subtle pixel shadow, preserving current alignment.
var _shop_text = function(_x, _y, _str, _col)
{
    // Declare the shadow colour locally.
    var _text_shadow = make_color_rgb(20, 12, 10);

    // One-pixel dark shadow.
    draw_set_color(_text_shadow);
    draw_text(_x + 1, _y + 1, _str);

    // Main text.
    draw_set_color(_col);
    draw_text(_x, _y, _str);
};

// Dim the room behind the open shop.
draw_set_alpha(0.82);
draw_set_color(c_black);
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(1);

// Wooden panel with warm border.
draw_set_color(_wood);
draw_rectangle(_px, _py, _px + _pw, _py + _ph, false);
draw_set_color(_border);
draw_rectangle(_px, _py, _px + _pw, _py + _ph, true);

// HEADER
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_font(Silkscreen12);
_shop_text(_cx, _py + 12, vendor_name, _gold);

draw_set_font(Silkscreen10);
_shop_text(_cx, _py + 37, "'Fine wood. Questionable workmanship.'", _muted);
_shop_text(_cx, _py + 57, "YOUR GOLD: " + string(global.gold), _paper);

// SHOP ITEMS
var _item_count = array_length(shop_items);
var _row_start = _py + 84;
var _row_spacing = 34;

for (var i = 0; i < _item_count; i++)
{
    var _item = shop_items[i];
    var _yy = _row_start + i * _row_spacing;
    var _owned = false;
    var _cost = 0;

    if (_item.kind == "table")
    {
        var _id = _item.table_id;
        if (variable_global_exists("tables_owned"))
        {
            if (_id >= 0 && _id < array_length(global.tables_owned))
                _owned = global.tables_owned[_id];
        }
        if (variable_global_exists("table_prices"))
        {
            if (_id >= 0 && _id < array_length(global.table_prices))
                _cost = global.table_prices[_id];
        }
    }
    else if (_item.kind == "arcade")
    {
        _owned = global.arcade_owned;
        _cost = arcade_price;
    }

    if (selected == i)
    {
        draw_set_color(_highlight);
        draw_rectangle(_px + 14, _yy - 4,
            _px + _pw - 14, _yy + 27, false);
    }

    draw_set_font(Silkscreen12);
    draw_set_halign(fa_left);
    _shop_text(_px + 26, _yy, _item.name,
        selected == i ? _gold : _paper);

    draw_set_halign(fa_right);
    var _price_text = _owned ? "OWNED" : string(_cost) + " G";
    _shop_text(_px + _pw - 26, _yy, _price_text,
        _owned ? make_color_rgb(159, 227, 123) : _paper);
}

// PURCHASE FEEDBACK
if (feedback_timer > 0)
{
    draw_set_halign(fa_center);
    draw_set_font(Silkscreen12);
    _shop_text(_cx, _py + _ph - 57, feedback_text, _gold);
}

// CONTROLS
draw_set_font(Silkscreen10);
draw_set_halign(fa_center);
_shop_text(_cx, _py + _ph - 25,
    "W/S: SELECT    E: BUY    ESC: CLOSE", _muted);

// RESTORE DRAW STATE
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);
