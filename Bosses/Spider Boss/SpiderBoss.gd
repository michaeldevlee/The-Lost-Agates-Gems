extends StaticBody2D

const ATTACK_THRESHOLD = 5
const IDLE = 'idle'
const PEW_LASER = 'pew_laser_eyes'
const ENERGY_BALL = 'energy_ball'
const TRACKING_MISSILES = 'shoot_tracking_missiles'

const TrackingMissile = preload('res://Bosses/Spider Boss/Attacks/TrackingMissile.tscn')
const PewLaser = preload('res://Bosses/Spider Boss/Attacks/PewLaser.tscn')
const EnergyBall = preload('res://Bosses/Spider Boss/Attacks/EnergyBall.tscn')

onready var left_eye_spawn_point = get_node("LeftEye")
onready var right_eye_spawn_point = get_node("RightEye")
onready var left_corner_rocket_spawn_point = get_node("LeftCornerRocket")
onready var right_corner_rocket_spawn_point = get_node("RightCornerRocket")
onready var energy_ball_spawn_point = get_node("EnergyBallPos")

var _anim_tree
var state_machine
var animation = IDLE
var _idle_count = 0
var _idle_rate = 1
var target

var hp = 100

func register_signals():
	EventBus.connect("boss_hit", self, "take_damage")

func _ready():
	register_signals()
	_anim_tree = $AnimationTree
	state_machine = _anim_tree.get('parameters/playback')
	state_machine.start("idle")
	state_machine.travel(IDLE)
	
func find_target():
	target = get_parent().get_node("Player")

func increase_idle_count():
	_idle_count += _idle_rate
	var should_attack = _idle_count > ATTACK_THRESHOLD

	var rng = int(rand_range(0, 100))
	
	if hp < 10 and should_attack:
		_idle_count = 0
		_idle_rate = rand_range(2, 3)
		animation = PEW_LASER
		pew_laser_eyes()
		yield(get_tree().create_timer(0.5),"timeout")
		if rng & 1:
			animation = ENERGY_BALL
			shoot_energy_ball()
		else:
			animation = TRACKING_MISSILES
			shoot_tracking_missiles()
	elif hp < 40 and _idle_count > ATTACK_THRESHOLD:
		_idle_count = 0
		_idle_rate = rand_range(1, 2)
		if rng > 66:
			animation = ENERGY_BALL
			shoot_energy_ball()
		elif rng > 33:
			animation = TRACKING_MISSILES
			shoot_tracking_missiles()
		else:
			animation = PEW_LASER
			pew_laser_eyes()
	elif hp < 75 and _idle_count > ATTACK_THRESHOLD:
		_idle_count = 0
		if rng > 60:
			animation = ENERGY_BALL
			shoot_energy_ball()
		elif rng > 30:
			animation = TRACKING_MISSILES
			shoot_tracking_missiles()
		else:
			animation = PEW_LASER
			pew_laser_eyes()
	elif _idle_count > ATTACK_THRESHOLD:
		_idle_count = 0
		animation = PEW_LASER
		pew_laser_eyes()

func pew_laser_eyes():
	state_machine.travel(PEW_LASER)
	find_target()
	for n in 4:
		var laser = PewLaser.instance()
		if n & 1:
			laser.global_transform = left_eye_spawn_point.global_transform
		else:
			laser.global_transform = right_eye_spawn_point.global_transform
		laser.target = target
		owner.add_child(laser)
		yield(get_tree().create_timer(0.2),"timeout")
	
func shoot_tracking_missiles():
	state_machine.travel(TRACKING_MISSILES)
	find_target()
	for n in 4:
		var randomTimer = rand_range(0.1, 0.3)
		var trackingMissile = TrackingMissile.instance()
		if n & 1:
			trackingMissile.global_transform = left_corner_rocket_spawn_point.global_transform
			trackingMissile.global_position.y += n * 4
		else:
			trackingMissile.global_transform = right_corner_rocket_spawn_point.global_transform
			trackingMissile.global_position.y += n * 4
		trackingMissile.target = target
		owner.add_child(trackingMissile)
		yield(get_tree().create_timer(randomTimer), 'timeout')
	
func shoot_energy_ball():
	state_machine.travel(ENERGY_BALL)
	var increment_location = 0
	find_target()
	for n in 3:
		var energyBall = EnergyBall.instance()
		energyBall.global_transform = energy_ball_spawn_point.global_transform
		energyBall.global_position.x += increment_location
		energyBall.target = target
		owner.add_child(energyBall)
		yield(get_tree().create_timer(1), 'timeout')
		increment_location += 100

func take_damage(amount):
	var old_hp = hp
	hp -= amount
	
func update_UI():
	get_node("../HP").text = 'HP: ' + str(hp)
	get_node("../Mode").text = "BOSS STAGE: " + str(animation)

# disable after testing
func manipulate_boss_hp():
	if Input.is_action_pressed('ui_down'):
		hp -= 1
	elif Input.is_action_pressed('ui_up'):
		hp += 1

func _physics_process(delta):
	pass
#	manipulate_boss_hp()
#	update_UI()
