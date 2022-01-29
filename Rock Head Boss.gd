extends StaticBody2D


const ATTACK_THRESHOLD = 5
const IDLE_1 = "Rock Head Idle 1"
const IDLE_2 = "Rock Head Idle 2"
const IDLE_STATES = [IDLE_1, IDLE_2]

const CORE_LASER_SHOOT = "Rock Head Core Laser Shoot"
const CORE_LASER_TRANSITION = "Rock Head Core Laser Transition"

const CHARGING_LASER = "Rock Head Charging Laser"
const CHARGING_LASER_TRANSITION = "Rock Head Charging Laser Transition"
const CHARGING_LASER_TRANSITION_OUT = "Rock Head Charging Laser Transition Out"

const LASER_HELLFIRE = "Rock Head Laser Hellfire"
const LASER_HELLFIRE_TRANSITION = "Rock Head Laser Hellfire Transition"

onready var charged_laser_spawn_point = get_node("Charged Laser Spawn Point")
onready var falling_laser_spawn_point = get_node("Falling Laser Spawn Point")

var _anim_tree 
var state_machine
var _idle_count = 0

var hp = 100

export (PackedScene) var ChargedLaser
export (PackedScene) var FallingLaser

func transition_to_idle():
	state_machine.travel(IDLE_STATES[randi() % IDLE_STATES.size()])

func register_signals():
	EventBus.connect("boss_hit", self, "take_damage")
	
func _ready():
	register_signals()
	_anim_tree = $AnimationTree
	state_machine = _anim_tree.get("parameters/playback")
	transition_to_idle()
	

func increase_idle_count():
	_idle_count += 1
	transition_to_idle()
	var should_attack = _idle_count > ATTACK_THRESHOLD

	if hp < 40 and should_attack:
		_idle_count = 0
		transition_to_activate_laser_hellfire()
	elif hp < 80 and should_attack:
		_idle_count = 0
		transition_to_shoot_charging_laser()
	elif should_attack:
		_idle_count = 0
		transition_to_shoot_core_laser()


func transition_to_shoot_core_laser():
	state_machine.travel(CORE_LASER_TRANSITION)
	
func shoot_core_laser():
	for n in 5:
		var laser = ChargedLaser.instance()
		laser.global_transform = charged_laser_spawn_point.global_transform
		laser.target = get_node("../Player")
		owner.add_child(laser)
		yield(get_tree().create_timer(1),"timeout")
	transition_to_idle()

func transition_to_shoot_charging_laser():
	state_machine.travel(CHARGING_LASER_TRANSITION) 
	
func transition_out_shoot_charging_laser():
	state_machine.travel(CHARGING_LASER_TRANSITION_OUT) 
	
func shoot_charging_laser():
	for n in 10:
		var laser = ChargedLaser.instance()
		laser.global_transform = charged_laser_spawn_point.global_transform
		laser.target = get_node("../Player")
		owner.add_child(laser)
		yield(get_tree().create_timer(0.3),"timeout")
	transition_out_shoot_charging_laser()

func transition_to_activate_laser_hellfire():
	state_machine.travel(LASER_HELLFIRE_TRANSITION) 

func activate_laser_hellfire():
	var viewport = get_viewport().get_visible_rect().size
	for n in 20:
		EventBus.emit_signal("camera_event_initiated", "SHAKE")
		var laser = FallingLaser.instance()
		owner.add_child(laser)
		laser.position = Vector2(rand_range(0, viewport.x), 0)
		yield(get_tree().create_timer(0.1),"timeout")
	transition_to_idle()

func take_damage(amount):
	hp -= amount
