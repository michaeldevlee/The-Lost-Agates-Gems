extends Node2D

func _ready():
	EventBus.connect("restart_game_initiated", self, "restart_game")

func restart_game():
	get_tree().reload_current_scene()
