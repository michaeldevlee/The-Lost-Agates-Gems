extends Camera2D

onready var shake_timer = get_node("Shake Timer")
onready var tween = get_node("Tween")

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
	EventBus.connect("tutorial_camera_started", self, "start_tutorial_camera")
	EventBus.connect("boss_picked", self, "start_boss_camera")

#debugging purposes
func _input(event):
	if Input.is_action_just_pressed("ui_down"):
		EventBus.emit_signal("screen_animation_initiated", "BOSS_DEATH")

func start_tutorial_camera():
	tween.interpolate_property(self, "position", position, position + Vector2(0, 270), 3,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	tween.start()
	yield(tween,"tween_completed")
	EventBus.emit_signal("tutorial_area_started")

func start_boss_camera(boss_name):		
	match boss_name:
		"Spider":
			tween.interpolate_property(self, "position", position, position + Vector2(-480, 0), 1,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
			tween.start()
			yield(tween,"tween_completed")
			EventBus.emit_signal("boss_started", boss_name)
		"Rock Head":
			tween.interpolate_property(self, "position", position, position + Vector2(480, 0), 1,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
			tween.start()
			yield(tween,"tween_completed")
			EventBus.emit_signal("boss_started", boss_name)

func _process(delta):
	if shake_timer and !shake_timer.is_stopped():
		shake_camera()

func _on_Shake_Timer_timeout():
	offset = Vector2(0,0)
