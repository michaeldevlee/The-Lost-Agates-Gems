extends Node2D

var boss_death_scene = preload("res://Cut Scenes/Boss Death Scene.tscn")
var animation_in_process : bool = false

func _ready():
	EventBus.connect("screen_animation_initiated", self, "play_screen_animation")
	EventBus.connect("screen_animation_ended", self, "enable_animations")

func enable_animations():
	animation_in_process = false

func play_screen_animation(animation_name):
	if animation_in_process:
		return
	
	match animation_name:
		"BOSS_DEATH":
			EventBus.emit_signal("boss_ended")
			add_child(boss_death_scene.instance())
			animation_in_process = true
