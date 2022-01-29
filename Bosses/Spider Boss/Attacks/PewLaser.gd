extends Area2D

var speed = 200

func _physics_process(delta):
	global_position += -transform.x * speed * delta

func _on_Laser_body_entered(body):
	if body.is_in_group('Player'):
		body.take_damage()
		queue_free()
