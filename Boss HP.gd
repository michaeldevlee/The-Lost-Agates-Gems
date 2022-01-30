extends TextureProgress

export (NodePath) var boss_path
var boss

func _ready():
	EventBus.connect("boss_hit", self, "update_health")
	initialize_boss_stats()

func initialize_boss_stats():
	if boss_path:
		boss = get_node(boss_path)
		max_value = boss.hp
		value = max_value
	
func update_health(dmg):
	value -= dmg
