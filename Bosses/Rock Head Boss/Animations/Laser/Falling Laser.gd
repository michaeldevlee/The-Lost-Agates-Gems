extends Area2D


var move = Vector2.ZERO
var speed = 5

func _physics_process(delta):
	move = Vector2.ZERO
	move = move.normalized() * speed
	move.y += gravity * delta
	position += move

func _on_Falling_Laser_body_entered(body):
	if(body.is_in_group("player")):
		EventBus.emit_signal("player_hit", 5)
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	print("exited screen")
	queue_free()




