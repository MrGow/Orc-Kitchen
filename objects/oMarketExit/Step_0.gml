/// oMarketExit — Step Event
// Automatically returns the player to the camp map.
if (room != Market || triggered || global.paused) exit;
if (!instance_exists(oPlayer)) exit;

if (place_meeting(x, y, oPlayer))
{
    triggered = true;
    global.day_phase = "camp_map";
    global.game_state = "camp_map";
    global.can_leave_mess_hall = false;
    room_goto(WarCampMap);
}
