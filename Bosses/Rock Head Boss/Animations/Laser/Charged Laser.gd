extends Area2D

var move = Vector2.ZERO
var look_vec = Vector2.ZERO
var speed = 5
var target = null

func _ready():
	look_vec = target.position - global_position
	rotation = look_vec.angle()

func _physics_process(delta):
	move = Vector2.ZERO
	move = move.move_toward(look_vec, delta)
	move = move.normalized() * speed
	position += move

func _on_Charged_Laser_body_entered(body):
	if(body.is_in_group("player")):
		EventBus.emit_signal("player_hit", 10)

func _on_VisibilityNotifier2D_screen_exited():
	print("exited screen")
	queue_free()




