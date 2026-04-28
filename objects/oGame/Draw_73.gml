/// oGame — Draw End
// Publish application_surface scale/offset.
// Useful later for mouse-to-world, UI alignment, screenshots, etc.

if (surface_exists(application_surface))
{
    var _sw = surface_get_width(application_surface);
    var _sh = surface_get_height(application_surface);

    var _dw = display_get_width();
    var _dh = display_get_height();

    var _s = floor(min(_dw / _sw, _dh / _sh));
    if (_s < 1) _s = 1;

    var _rw = _sw * _s;
    var _rh = _sh * _s;

    global._appsurf_scale = _s;
    global._appsurf_xoff = floor((_dw - _rw) * 0.5);
    global._appsurf_yoff = floor((_dh - _rh) * 0.5);
}