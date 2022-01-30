extends Control

func _ready():
	EventBus.connect("boss_started", self, "initialize_UI")
	EventBus.connect("restart_game_initiated", self, "hide_UI")
	EventBus.connect("boss_ended", self, "hide_UI")

func initialize_UI(boss_name):
	print("initialize")
	set_visible(true)

func hide_UI():
	set_visible(false)
