extends StaticBody2D

const ATTACK_THRESHOLD = 3
const IDLE = 'idle'
const PEW_LASER = 'pew_laser_eyes'
const SINGLE_MISSILE = 'shoot_single_missile'
const COLOSSUS = 'colossus_beam'
const TRACKING_MISSILES = 'shoot_tracking_missiles'

var _anim_tree
var state_machine
var animation = IDLE
var _idle_count = 0
var target

var hp = 100

const TrackingMissile = preload('res://Bosses/Spider Boss/Attacks/TrackingMissile.tscn')
const PewLaser = preload('res://Bosses/Spider Boss/Attacks/PewLaser.tscn')

func _ready():
	_anim_tree = $AnimationTree
	state_machine = _anim_tree.get('parameters/playback')
	state_machine.start("idle")
	state_machine.travel(IDLE)
	
func find_target():
	print('finding target')
	target = get_parent().get_node("Player")

func increase_idle_count():
	_idle_count += 1
	if hp < 33 and _idle_count > ATTACK_THRESHOLD:
		_idle_count = 0
		animation = COLOSSUS
		# attack func
	elif hp < 66 and _idle_count > ATTACK_THRESHOLD:
		_idle_count = 0
		# weighted random leaning towards tracking.
		# animation = tracking / single / pew_laser
		# attack func
	elif hp < 80 and _idle_count > ATTACK_THRESHOLD:
		_idle_count = 0
		animation = TRACKING_MISSILES
		shoot_tracking_missiles()
		# weighted random leaning towards single missile
		# animation = tracking / single / pew-laser
		# attack func
	elif _idle_count > ATTACK_THRESHOLD:
		_idle_count = 0
		animation = PEW_LASER
		pew_laser_eyes()
		# weighted random leaning towards pew laser
		#animation = single / pew
		#animation = PEW_LASER
		#pew_laser_eyes()

		
func pew_laser_eyes():
	state_machine.travel(PEW_LASER)
	find_target()
	var laser = PewLaser.instance()
	owner.add_child(laser)
	laser.transform = transform
	animation = IDLE
	
func shoot_single_missile():
	print('hi')
	state_machine.travel(SINGLE_MISSILE)
	# var bigMissile = BigMissile.instance()
	# owner.add_child(bigMissile)
	# bigMissile.transform = transform
	
func shoot_tracking_missiles():
	state_machine.travel(TRACKING_MISSILES)
	find_target()
	print('this is the boss location', self.position)
	for n in 8:
		var trackingMissile = TrackingMissile.instance()
		owner.add_child(trackingMissile)
		trackingMissile.global_position.x = self.global_position.x
		trackingMissile.global_position.y = self.global_position.y + 100
		trackingMissile.start(get_node("Spider").global_transform, target)
		trackingMissile.transform = transform
		yield(get_tree().create_timer(0.1), 'timeout')
	animation = IDLE
	
func take_damage():
	if Input.is_action_pressed('ui_down'):
		hp -= 1
	if Input.is_action_pressed('ui_up'):
		hp += 1

func update_UI():
	get_node("../HP").text = 'HP: ' + str(hp)
	get_node("../Mode").text = "BOSS STAGE: " + str(animation)

func _physics_process(delta):
	print('idlecount', _idle_count)
	take_damage()
	update_UI()
