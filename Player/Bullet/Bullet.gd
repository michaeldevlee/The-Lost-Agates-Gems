extends AnimatedSprite

var speed = 750

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_Bullet_body_entered(body):
	if body.is_in_group("boss"):
		# emit signal -> decrease boss' health
		body.take_damage()
		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	print("exited screen")
	queue_free()
