class_name TrackingMissile

extends Area2D

export(int) var speed = rand_range(10, 100)
export(int) var steer_force = 50.0
export var rotation_speed = PI

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var target = null

func start(_transform, _target):
	print('this is my starting position', self.position)
	global_transform = _transform
	rotation += rand_range(-0.09, 0.09)
	velocity = transform.x * speed
	target = _target

func seek():
	var steer = Vector2.ZERO
	if target:
		var desired = (target.global_position - global_position).normalized() * speed
		steer = (desired - velocity).normalized() * steer_force
	return steer
	
func _physics_process(delta):
	acceleration += seek()
	velocity += acceleration * delta
	velocity = velocity.clamped(speed)
	rotation = velocity.angle()
	global_position += velocity * delta

func explode():
	set_physics_process(false)
	queue_free()
	
func _on_VisibilityNotifier2D_screen_exited():
	explode()
	
func _on_Timer_timeout():
	explode()
	
func _on_TrackingMissile_body_entered(body):
	if body.get_name() == 'Player':
		explode()
	elif body.get_name() == 'TrackingMissile':
		explode()
	
