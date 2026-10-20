/// oPlayerUpgradeNotice — Create
/// Place one nonpersistent, unsprited instance in Home.

notice_active = false;
notice_data = undefined;
notice_timer = 0;
notice_duration = round(room_speed * 4.2);
notice_fade_frames = max(1, round(room_speed * 0.45));

depth = -20000;
visible = true;
