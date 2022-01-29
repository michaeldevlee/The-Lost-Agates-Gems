extends KinematicBody2D

export (int) var speed = 300
export (int) var gravity = 900
export var jump_impulse = 600
var dash_multiplier = 1
var velocity : Vector2 = Vector2()

var hp = 100
export (PackedScene) var Bullet

onready var sprite = get_node("Player Sprite")
onready var bullet_spawn_point = get_node("Bullet Spawn Point")
onready var dash_tween = get_node("Dash Tween")
onready var anim_player = get_node("AnimationPlayer")

var is_dashing : bool = false
var player_facing_direction = "Right"

func _ready():
	register_signals()
	

func move_from_input():
	velocity.x = 0
	if(Input.is_action_pressed("player_left")):
		velocity.x -= speed * dash_multiplier
		anim_player.play("Player Walk")
		print(player_facing_direction)
	elif(Input.is_action_pressed("player_right")):
		velocity.x += speed * dash_multiplier
		anim_player.play("Player Walk")
		print(player_facing_direction)
	else:
		anim_player.play("Player Idle")
	if(Input.is_action_just_pressed("player_jump")) and is_on_floor():
		velocity.y -= jump_impulse
	if(Input.is_action_just_pressed("player_dash")):
		if !is_dashing and abs(velocity.x) > 0:
			is_dashing = true
			dash_multiplier = 3
			yield(get_tree().create_timer(0.4),"timeout")
			dash_multiplier = 1
			is_dashing = false
	if(Input.is_action_just_pressed("player_ducking")) and is_on_floor():
		pass
		
	velocity = move_and_slide(velocity, Vector2.UP, true)


func apply_gravity(delta):
	velocity.y += gravity * delta

func update_sprite_direction():
	if velocity.x < 0:
		player_facing_direction = "Left"
		bullet_spawn_point.position.x *= -1
		sprite.set_flip_h(true)
	elif velocity.x > 0:
		player_facing_direction = "Right"
		bullet_spawn_point.position.x = abs(bullet_spawn_point.position.x)
		sprite.set_flip_h(false)
		
func shoot_projectile_from_input():
	if(Input.is_action_pressed("player_shoot")):
		if Bullet:
			var bullet = Bullet.instance()
			owner.add_child(bullet)
			if bullet.is_in_group("Bullet"):
				bullet.global_position = bullet_spawn_point.global_position
				bullet.player_direction = player_facing_direction

func take_damage(amount):
	hp -= amount

func register_signals():
	EventBus.connect("player_hit", self, "take_damage")

#debugging purposes
func _input(event):
	if Input.is_action_just_pressed("ui_down"):
		EventBus.emit_signal("player_hit", 2)

func _physics_process(delta):
	move_from_input()
	apply_gravity(delta)
	update_sprite_direction()
	shoot_projectile_from_input()
