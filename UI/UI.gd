extends Control

func _ready():
	EventBus.connect("boss_started", self, "initialize_UI")

func initialize_UI(boss_name):
	print("initialize")
	set_visible(true)
