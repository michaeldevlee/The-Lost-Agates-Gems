extends TextureProgress

var rock_head = preload("res://Bosses/Rock Head Boss/Rock Head Boss.tscn")
var spider = preload("res://Bosses/Spider Boss/SpiderBoss.tscn")

func _ready():
	EventBus.connect("boss_hit", self, "update_health")
	EventBus.connect("boss_picked", self, "initialize_boss_stats")

func initialize_boss_stats(boss_name):
	match boss_name:
		"Rock Head":
			max_value = 5000
			value = max_value
		"Spider":
			max_value = 15000 
			value = max_value
	
func update_health(dmg):
	value -= dmg
