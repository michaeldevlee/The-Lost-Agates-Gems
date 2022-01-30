extends Area2D

var speed = 750
var player_direction : String = "Right"

func _physics_process(delta):
	if player_direction == "Right":
		position += transform.x * speed * delta
	else:
		position -= transform.x * speed * delta

func _on_Bullet_body_entered(body):
	if body.is_in_group("boss"):
		print('hitting boss')
		EventBus.emit_signal("boss_hit", 1)
		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
