extends CanvasLayer

onready var anim_player = get_node("AnimationPlayer")

func _ready():
	EventBus.connect("transition_initiated", self, "execute_transition")

func execute_transition(transition_name, next_scene):
	if transition_name == null:
		return

	match transition_name:
		"FADE_OUT":
			anim_player.play("Fade Out")
		"FADE_IN":
			anim_player.play_backwards("Fade Out")

	yield(anim_player,"animation_finished")
	
	match next_scene:
		"RESTART":
			EventBus.emit_signal("restart_game_initiated")
		"START":
			EventBus.emit_signal("game_initiated")
