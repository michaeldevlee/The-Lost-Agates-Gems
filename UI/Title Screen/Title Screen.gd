extends CanvasLayer

onready var title_screen = get_node("MarginContainer")
onready var anim_player = get_node("AnimationPlayer")

func fade_out_title_screen():
	anim_player.play("Fade Out")

func transition_to_tutorial_area():
	EventBus.emit_signal("tutorial_camera_started")
	queue_free()

func _on_Play_Button_button_up():
	fade_out_title_screen()
