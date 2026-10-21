/// oGlubVendor — Draw GUI End
// Above the oGame pause shade, like the carpenter shop.
if (!shop_open) exit;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _w = min(478, _gw-12);
var _h = min(337, _gh-12);
var _l = (_gw-_w)*0.5;
var _t = (_gh-_h)*0.5;
var _cx = _gw*0.5;
var _wood = make_color_rgb(39, 31, 24);
var _gold = make_color_rgb(211, 164, 93);
var _paper = make_color_rgb(234, 215, 180);
var _font = asset_get_index("PixelifyRegular12");
if (_font != -1) draw_set_font(_font);
draw_set_halign(fa_center);
draw_set_valign(fa_top);

draw_set_alpha(0.80);
draw_set_color(c_black);
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(1);
draw_set_color(_wood);
draw_rectangle(_l, _t, _l+_w, _t+_h, false);
draw_set_color(_gold);
draw_rectangle(_l, _t, _l+_w, _t+_h, true);
draw_text(_cx, _t+9, "GLUB'S SCHOOL OF AQUATIC VIOLENCE");
draw_set_color(_paper);
draw_text(_cx, _t+29, "'FISHIN' IS FER COWARDS. FISHWALLOPIN'!' ");
draw_text(_cx, _t+47, "YOUR GOLD: " + string(global.gold));

for (var _i=0; _i<array_length(shop_items); _i++)
{
    var _item = shop_items[_i];
    var _yy = _t+73 + _i*48;
    var _owned = false;
    for (var _j=0; _j<array_length(global.fishing_owned_cards); _j++)
        if (global.fishing_owned_cards[_j] == _item.key) { _owned=true; break; }

    if (_i == selected)
    {
        draw_set_color(make_color_rgb(83, 65, 41));
        draw_rectangle(_l+11, _yy-2, _l+_w-11, _yy+43, false);
    }
    draw_set_halign(fa_left);
    draw_set_color(_i == selected ? c_yellow : _paper);
    draw_text(_l+22, _yy+1, _item.name);
    draw_set_color(make_color_rgb(172, 159, 132));
    draw_text(_l+22, _yy+21, _item.desc);
    draw_set_halign(fa_right);
    draw_set_color(_owned ? c_lime : _paper);
    draw_text(_l+_w-21, _yy+1, _owned ? "OWNED" : string(_item.price) + " G");
}

draw_set_halign(fa_center);
if (feedback_timer > 0)
{
    draw_set_color(c_yellow);
    draw_text(_cx, _t+_h-46, feedback_text);
}
draw_set_color(_paper);
draw_text(_cx, _t+_h-23, "W/S: SELECT    E: BUY    ESC: CLOSE");

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
