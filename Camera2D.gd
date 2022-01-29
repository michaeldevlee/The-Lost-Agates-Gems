extends Camera2D

onready var shake_timer = get_node("Shake Timer")

var current_state : String
export var shake_strength = 6

func _ready():
	register_signals()

func shake_camera():
	offset.x = rand_range(-1.0, 1.0) * shake_strength
	offset.y = rand_range(-1.0, 1.0) * shake_strength

func update_state(new_state):
	current_state = new_state
	match new_state:
		"SHAKE":
			shake_timer.start(0.2)

func register_signals():
	EventBus.connect("camera_event_initiated", self, "update_state")

#debugging purposes
func _input(event):
	if Input.is_action_just_pressed("ui_down"):
		EventBus.emit_signal("camera_event_initiated", "SHAKE")

func _process(delta):
	if shake_timer and !shake_timer.is_stopped():
		shake_camera()

func _on_Shake_Timer_timeout():
	offset = Vector2(0,0)
