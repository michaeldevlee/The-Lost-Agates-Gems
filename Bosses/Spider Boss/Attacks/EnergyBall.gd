extends Area2D

var speed = rand_range(5, 75)
var steer_force = 25.0
var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO

var target = null

func _ready():
	rotation += rand_range(-0.09, 0.09)
	velocity = transform.x * speed

func seek():
	var steering_force = Vector2.ZERO
	if target:
		var distance_to_target = target.global_position - global_position
		var desired_vel = distance_to_target.normalized() * speed
		steering_force = (desired_vel - velocity).normalized() * speed
	return steering_force
	
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
	
func _on_EnergyBall_body_entered(body):
	if body.get_name() == 'Player':
		print('Hit with EnergyBall')
		EventBus.emit_signal('player_hit', 20)
		explode()
	elif body.get_name() == 'EnergyBall':
		print('exploded with self')
		explode()
	
