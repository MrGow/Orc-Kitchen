/// oOrderTicketController — Draw GUI End (FULL EVENT)
/// Bottom wooden order rail with animated parchment tickets.
if (room != MessHall) exit;
if (global.day_phase != "serving" && global.day_phase != "closing") exit;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _sx = _gw/640;
var _sy = _gh/360;
var _wood = make_color_rgb(43,30,23);
var _gold = make_color_rgb(238,195,109);
var _ink = make_color_rgb(61,43,27);

// Opaque rail prevents distracting feet/tiles behind ticket text.
draw_set_alpha(0.93);
draw_set_color(_wood);
draw_rectangle(0,270*_sy,_gw,_gh,false);
draw_set_alpha(1);
draw_set_color(make_color_rgb(137,94,54));
draw_rectangle(0,269*_sy,_gw,273*_sy,false);

draw_set_font(Silkscreen10);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(_gold);
draw_text(10*_sx,272*_sy,"ORDERS  Q / E : SWITCH");

// Draw normal tickets in arrival order, active ticket last/on top.
for (var _pass=0;_pass<2;_pass++)
{
    for (var _i=0;_i<array_length(tickets);_i++)
    {
        var _t = tickets[_i];
        var _active = (_t.ticket_id == selected_id && _t.status == "waiting");
        if ((_pass==1) != _active) continue;

        var _prepared = _t.status == "prepared";
        var _w = _active ? slot_selected_w : slot_normal_w;
        var _h = _active ? 78 : slot_h;
        var _px = _t.gui_x;
        var _py = _t.gui_y;
        if (_px > 645 || _px < -215) continue;
        var _x1 = round(_px*_sx);
        var _y1 = round(_py*_sy);
        var _x2 = round((_px+_w)*_sx);
        var _y2 = round((_py+_h)*_sy);

        draw_set_color(_active ? make_color_rgb(242,215,160) : make_color_rgb(197,169,128));
        if (_prepared) draw_set_color(make_color_rgb(126,123,116));
        draw_rectangle(_x1,_y1,_x2,_y2,false);
        draw_set_color(_active ? _gold : make_color_rgb(105,75,49));
        draw_rectangle(_x1,_y1,_x2,_y2,true);
        if (_active)
        {
            draw_rectangle(_x1+2,_y1+2,_x2-2,_y2-2,true);
        }
        draw_set_color(_ink);
        draw_set_font(Silkscreen10);
        draw_text(_x1+7*_sx,_y1+5*_sy,"#"+string(_t.ticket_id));

        var _sp = _t.sprite;
        if (_sp != -1)
        {
            var _max = _active ? 40 : 32;
            var _scale = min(_max/max(1,sprite_get_width(_sp)), _max/max(1,sprite_get_height(_sp)));
            draw_sprite_ext(_sp,0,round((_px+28)*_sx),round((_py+42)*_sy),_scale*_sx,_scale*_sy,0,c_white,_prepared ? 0.45 : 1);
        }
        var _shortname = _t.recipe == "bat_wings" ? "BAT WINGS" : "SKEWERED RAT";
        draw_set_color(_ink);
        draw_set_font(Silkscreen10);
        draw_text(round((_px+52)*_sx),round((_py+32)*_sy),_shortname);
        draw_text(round((_px+52)*_sx),round((_py+47)*_sy),_t.topping == "" ? "PLAIN" : "WITH RELISH");

        if (_prepared)
        {
            draw_set_color(make_color_rgb(37,105,42));
            var _check_x = (_px+_w/2)*_sx;
            var _check_y = (_py+20)*_sy;
            draw_line_width(_check_x-12*_sx,_check_y, _check_x-3*_sx,_check_y+11*_sy,4*_sx);
            draw_line_width(_check_x-3*_sx,_check_y+11*_sy,_check_x+17*_sx,_check_y-12*_sy,4*_sx);
        }
    }
}
if (locked_notice > 0)
{
    draw_set_color(make_color_rgb(255,198,123));
    draw_set_halign(fa_center);
    draw_set_font(Silkscreen10);
    draw_text(_gw/2,252*_sy,"CLEAR PREP COUNTER FIRST!");
    draw_set_halign(fa_left);
}

draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
