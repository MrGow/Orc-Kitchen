/// oVendorCarpenter — Draw GUI End Event
// GUI End deliberately draws ABOVE oGame's pause overlay.
// This is a functional placeholder menu; restyle later.

if (!shop_open || room != Market) exit;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _cx = _gw * 0.5;
var _px = _cx - 215;
var _py = max(12, (_gh - 300) * 0.5);
var _pw = 430;
var _ph = 300;

var _wood = make_color_rgb(49, 34, 24);
var _border = make_color_rgb(171, 119, 61);
var _paper = make_color_rgb(233, 210, 162);

// Backdrop and wooden board.
draw_set_alpha(0.82);
draw_set_color(c_black);
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(1);
draw_set_color(_wood);
draw_rectangle(_px, _py, _px + _pw, _py + _ph, false);
draw_set_color(_border);
draw_rectangle(_px, _py, _px + _pw, _py + _ph, true);

draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_yellow);
draw_text(_cx, _py + 14, vendor_name);
draw_set_color(_paper);
draw_text(_cx, _py + 36, "'Fine wood. Questionable workmanship.'");
draw_text(_cx, _py + 58, "YOUR GOLD: " + string(global.gold));

// Purchasable table entries.
for (var i = 0; i < array_length(shop_table_ids); i++)
{
    var _id = shop_table_ids[i];
    var _yy = _py + 91 + i * 36;
    var _owned = false;
    var _cost = 0;

    if (variable_global_exists("tables_owned")
        && _id < array_length(global.tables_owned))
        _owned = global.tables_owned[_id];

    if (variable_global_exists("table_prices")
        && _id < array_length(global.table_prices))
        _cost = global.table_prices[_id];

    if (selected == i)
    {
        draw_set_color(make_color_rgb(106, 71, 42));
        draw_rectangle(_px + 14, _yy - 4, _px + _pw - 14, _yy + 26, false);
    }

    draw_set_halign(fa_left);
    draw_set_color(selected == i ? c_yellow : _paper);
    draw_text(_px + 29, _yy, shop_table_names[i]);

    draw_set_halign(fa_right);
    draw_set_color(_owned ? c_lime : _paper);
    draw_text(_px + _pw - 29, _yy, _owned ? "OWNED" : string(_cost) + " G");
}

draw_set_halign(fa_center);
if (feedback_timer > 0)
{
    draw_set_color(c_yellow);
    draw_text(_cx, _py + 245, feedback_text);
}

draw_set_color(_paper);
draw_text(_cx, _py + 274, "UP/DOWN: SELECT   E/ENTER: BUY   ESC: CLOSE");

// Restore drawing state.
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_set_color(c_white);
