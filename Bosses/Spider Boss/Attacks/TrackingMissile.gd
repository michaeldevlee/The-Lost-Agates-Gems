extends Area2D

var speed = rand_range(100, 250)
var steer_force = 75.0
var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO

var target = null

func _ready():
	rotation += rand_range(-0.09, 0.09)
	velocity = transform.x * speed

func seek():
	var distance_to_target = target.global_position - global_position
	var desired_vel = distance_to_target.normalized() * speed
	var steering_force = (desired_vel - velocity).normalized() * speed
	return steering_force
	
func _physics_process(delta):

	acceleration += seek()
	velocity += acceleration * delta
	velocity = velocity.clamped(speed)
	rotation = velocity.angle()
	global_position += velocity * delta

func explode():
	EventBus.emit_signal("camera_event_initiated", "SHAKE")
	set_physics_process(false)
	queue_free()
	
func _on_VisibilityNotifier2D_screen_exited():
	explode()
	
func _on_Timer_timeout():
	explode()
	
func _on_TrackingMissile_body_entered(body):
	if body.get_name() == 'Player':
		EventBus.emit_signal('player_hit', 100)
		print('missile hit player')
		explode()
	elif body.get_name() == 'TrackingMissile':
		explode()
	

