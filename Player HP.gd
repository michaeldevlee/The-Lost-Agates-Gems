extends TextureProgress

export (NodePath) var player_path
var player

func _ready():
	EventBus.connect("player_hit", self, "update_health")
	initialize_player_stats()

func initialize_player_stats():
	if player_path:
		player = get_node(player_path)
		print(player)
#		if player is Player:
#			max_value = player.hp
#			value = max_value
#			print(max_value)
	
func update_health(dmg):
	value -= dmg

