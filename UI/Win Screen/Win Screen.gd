extends CanvasLayer

onready var play_button_text = get_node("Win Screen/Play Again Button/Label")
onready var anim_player = get_node("Win Screen/AnimationPlayer")

func fade_in_menu():
	anim_player.play("Fade In")

func _on_Play_Again_Button_mouse_entered():
	play_button_text.set("custom_colors/font_color", Color(1,0,0))

func _on_Play_Again_Button_mouse_exited():
	play_button_text.set("custom_colors/font_color", Color(1,1,0))

func _on_Play_Again_Button_button_up():
	EventBus.emit_signal("transition_initiated", "FADE_IN", "RESTART")
	anim_player.play("Fade Out")
