extends Control

onready var anim_player = get_node("AnimationPlayer")

func _ready():
	EventBus.connect("tutorial_area_started", self, "show_tutorial")
	EventBus.connect("boss_picked", self, "hide_tutorial")

func show_tutorial():
	anim_player.play("Fade In")

func hide_tutorial(boss_name):
	anim_player.play("Fade Out")
