extends Node2D

onready var win_screen = get_node("Win Screen")
onready var death_screen = get_node("Death Screen")

func _ready():
	EventBus.connect("menu_item_initiated", self, "show_menu")

func show_menu(name):
	match name:
		"Win Screen":
			win_screen.fade_in_menu()
		"Death Screen":
			death_screen.fade_in_menu()
			
