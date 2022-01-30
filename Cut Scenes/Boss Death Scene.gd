extends CanvasLayer

onready var anim_player = get_node("AnimationPlayer")

func slow_motion_effect():
	Engine.time_scale = 0.2
	yield(get_tree().create_timer(0.2),"timeout")
	Engine.time_scale = 1

func start_screen_shake():
	white_in_and_out()
	for x in 20:
		EventBus.emit_signal("camera_event_initiated", "SHAKE")
		yield(get_tree().create_timer(0.2),"timeout")
	
func white_in_and_out():
	anim_player.play("White_In_And_Out")
	yield(anim_player,"animation_finished")
	EventBus.emit_signal("screen_animation_ended")
	print('freed')
	EventBus.emit_signal("menu_item_initiated", "Win Screen")
	queue_free()
