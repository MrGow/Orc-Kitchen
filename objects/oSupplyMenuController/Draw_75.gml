/// oSupplyMenuController — Draw GUI End
/// Big bobbing sprite tiles; Silkscreen UI.

if (room != MessHall) exit;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _cx = _gw * 0.5;
var _count = array_length(items);

var _ink = make_color_rgb(20, 13, 11);
var _wood = make_color_rgb(45, 30, 22);
var _edge = make_color_rgb(158, 111, 61);
var _cream = make_color_rgb(236, 211, 167);
var _gold = make_color_rgb(243, 198, 100);

draw_set_alpha(0.76);
draw_set_color(c_black);
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(1);

var _pw = min(510, _gw - 14);
var _ph = min(304, _gh - 12);
var _x1 = _cx - _pw * 0.5;
var _y1 = (_gh - _ph) * 0.5;

draw_set_color(_wood);
draw_rectangle(_x1, _y1, _x1 + _pw, _y1 + _ph, false);
draw_set_color(_edge);
draw_rectangle(_x1, _y1, _x1 + _pw, _y1 + _ph, true);
draw_rectangle(_x1 + 3, _y1 + 3, _x1 + _pw - 3, _y1 + _ph - 3, true);

draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_font(Silkscreen12);
draw_set_color(_ink);
var _title = (source_type == "meat") ? "MEAT RACK" : "PLATE HOLDER";
draw_text(_cx + 1, _y1 + 14, _title);
draw_set_color(_gold);
draw_text(_cx, _y1 + 13, _title);

draw_set_font(Silkscreen10);
draw_set_color(_cream);
draw_text(_cx, _y1 + 35, "CHOOSE YER SUPPLIES!");

// Up to three tall tiles in this first version; more options can
// later use scrolling or pages without changing the station API.
var _tile_w = (_count == 1) ? 164 : (_count == 2 ? 180 : 140);
var _tile_gap = 16;
var _full_w = _count * _tile_w + max(0, _count - 1) * _tile_gap;
var _tile_start = _cx - _full_w * 0.5;
var _ty = _y1 + 62;
var _tile_h = 170;

for (var i = 0; i < _count; i++)
{
    var _it = items[i];
    var _selected = (i == selected);
    var _xx = _tile_start + i * (_tile_w + _tile_gap);
    var _yy = _ty + (_selected ? -5 : 0);

    draw_set_color(_selected ? make_color_rgb(105, 73, 42) : make_color_rgb(65, 48, 37));
    draw_rectangle(_xx, _yy, _xx + _tile_w, _yy + _tile_h, false);
    draw_set_color(_selected ? _gold : make_color_rgb(119, 94, 69));
    draw_rectangle(_xx, _yy, _xx + _tile_w, _yy + _tile_h, true);
    if (_selected)
        draw_rectangle(_xx + 2, _yy + 2, _xx + _tile_w - 2, _yy + _tile_h - 2, true);

    var _icon_x = _xx + _tile_w * 0.5;
    var _icon_y = _yy + 70 + sin(menu_anim + i * 1.8) * (_selected ? 4 : 2);

    if (_it.sprite != -1)
    {
        // Scale only as needed so varying ingredient sizes fit tiles.
        var _sw = max(1, sprite_get_width(_it.sprite));
        var _sh = max(1, sprite_get_height(_it.sprite));
        var _s = min(2, min(105 / _sw, 94 / _sh));
        draw_sprite_ext(_it.sprite, 0, round(_icon_x), round(_icon_y),
            _s, _s, 0, c_white, 1);
    }

    draw_set_font(Silkscreen10);
    draw_set_color(_ink);
    draw_text(_icon_x + 1, _yy + 128, _it.name);
    draw_set_color(_selected ? _gold : _cream);
    draw_text(_icon_x, _yy + 127, _it.name);

    draw_set_color(make_color_rgb(188, 171, 143));
    draw_text(_icon_x, _yy + 146, "STOCK: " + string(_it.stock));
}

draw_set_font(Silkscreen10);
draw_set_color(_cream);
draw_text(_cx, _y1 + _ph - 37, "LEFT/RIGHT: CHOOSE   E/A: TAKE");
draw_text(_cx, _y1 + _ph - 20, "ESC/B: BACK");

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
draw_set_alpha(1);
draw_set_color(c_white);
