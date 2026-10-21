/// oFishBattleController — Room Start
// Runs after oGame's Room Start, so this mode owns its state.
if (room != FishBattle) exit;
global.game_state = "fishing";
global.day_phase = "fishing";
global.paused = false;
global.recipe_menu_open = false;
global.player_can_move = false;
global.player_can_interact = false;
