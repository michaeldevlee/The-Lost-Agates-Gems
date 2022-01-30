extends StaticBody2D


const ATTACK_THRESHOLD = 5
const IDLE_1 = "Rock Head Idle 1"
const IDLE_2 = "Rock Head Idle 2"
const IDLE_STATES = [IDLE_1, IDLE_2]

const CORE_LASER_SHOOT = "Rock Head Core Laser Shoot"
const CORE_LASER_TRANSITION = "Rock Head Core Laser Transition"

const CHARGING_LASER = "Rock Head Charging Laser"
const CHARGING_LASER_TRANSITION = "Rock Head Charging Laser Transition"

const LASER_HELLFIRE = "Rock Head Laser Hellfire"
const LASER_HELLFIRE_TRANSITION = "Rock Head Laser Hellfire Transition"

onready var charged_laser_spawn_point = get_node("Charged Laser Spawn Point")
onready var falling_laser_spawn_point = get_node("Falling Laser Spawn Point")

onready var top_sprite = $"Top Sprite"
onready var bot_sprite = $"Bottom Sprite"
var top_sprite_color
var bot_sprite_color
var top_sprite_hit_color
var bot_sprite_hit_color
var _anim_tree 
var state_machine
var _idle_count = 0
var _attack_count = 0

var hp = 1000

export (PackedScene) var CoreLaser
export (PackedScene) var ChargedLaser
export (PackedScene) var FallingLaser

func transition_to_idle():
	state_machine.travel(IDLE_STATES[randi() % IDLE_STATES.size()])

func register_signals():
	EventBus.connect("boss_hit", self, "take_damage")
	EventBus.connect("boss_started", self, "activate_boss")
	
func activate_boss(boss_name):
	if boss_name == "Rock Head":
		_anim_tree.set_active(true)
		transition_to_idle()
	
func _ready():
	register_signals()
	_anim_tree = $AnimationTree
	state_machine = _anim_tree.get("parameters/playback")
	
	top_sprite_color = Color(top_sprite.modulate.r,top_sprite.modulate.g,top_sprite.modulate.b)
	bot_sprite_color = Color(bot_sprite.modulate.r,bot_sprite.modulate.g,bot_sprite.modulate.b)
	top_sprite_hit_color = Color(top_sprite.modulate.r+0.3,top_sprite.modulate.g+0.3,top_sprite.modulate.b)
	bot_sprite_hit_color = Color(bot_sprite.modulate.r+0.3,bot_sprite.modulate.g+0.3,bot_sprite.modulate.b)
	
func increase_idle_count():
	_idle_count += 1
	var should_attack = _idle_count > ATTACK_THRESHOLD

	if hp < 400 and should_attack:
		_idle_count = 0
		transition_to_activate_laser_hellfire()
	elif hp < 700 and should_attack:
		_idle_count = 0
		transition_to_shoot_charging_laser()
	elif should_attack:
		_idle_count = 0
		transition_to_shoot_core_laser()
	else:
		transition_to_idle()


func transition_to_shoot_core_laser():
	state_machine.travel(CORE_LASER_TRANSITION)
	
func shoot_core_laser():
	if _attack_count < 5:
		var laser = CoreLaser.instance()
		laser.global_transform = charged_laser_spawn_point.global_transform
		laser.target = get_node("../Player")
		owner.add_child(laser)
		_attack_count += 1
	else:
		_attack_count = 0
		transition_to_idle()

func transition_to_shoot_charging_laser():
	state_machine.travel(CHARGING_LASER_TRANSITION) 
	
func shoot_charging_laser():
	if _attack_count < 15:
		var laser = ChargedLaser.instance()
		laser.global_transform = charged_laser_spawn_point.global_transform
		laser.target = get_node("../Player")
		owner.add_child(laser)
		_attack_count += 1
	else:
		_attack_count = 0
		transition_to_idle()

func transition_to_activate_laser_hellfire():
	state_machine.travel(LASER_HELLFIRE_TRANSITION) 

func activate_laser_hellfire():
	var viewport = get_viewport().get_visible_rect().size
	for n in 100:
		EventBus.emit_signal("camera_event_initiated", "SHAKE")
		var laser = FallingLaser.instance()
		owner.add_child(laser)
		laser.position = Vector2(rand_range(0, viewport.x), 0)
		yield(get_tree().create_timer(0.7),"timeout")
		var c_laser = ChargedLaser.instance()
		c_laser.global_transform = charged_laser_spawn_point.global_transform
		c_laser.target = get_node("../Player")
		owner.add_child(c_laser)
	transition_to_idle()

func show_hitmarker():
	top_sprite.set_modulate(top_sprite_hit_color)
	bot_sprite.set_modulate(bot_sprite_hit_color)
	yield(get_tree().create_timer(0.1),"timeout")
	top_sprite.set_modulate(top_sprite_color)
	bot_sprite.set_modulate(bot_sprite_color)

func take_damage(amount):
	show_hitmarker()
	hp -= amount
