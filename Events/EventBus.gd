extends Node

signal player_hit(dmg_amt)
signal boss_hit(dmg_amt)
signal camera_event_initiated(type)

signal player_stats_initailized(health)

signal tutorial_camera_started()
signal tutorial_area_started()
signal boss_picked(boss_name)
signal boss_started(boss_name)
signal boss_ended()

signal transition_initiated(fade_in_or_out)
signal restart_game_initiated()
signal game_initiated()
signal menu_item_initiated(name)

signal screen_animation_initiated(name)
signal screen_animation_ended()
