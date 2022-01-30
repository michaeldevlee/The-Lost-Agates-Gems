extends Node2D

onready var left_bound = get_node("Bound Left/CollisionShape2D")
onready var right_bound = get_node("Right Bound/CollisionShape2D")
onready var left_entrance = get_node("Spider Boss Entrance")
onready var right_entrance = get_node("Rock Head Entrance")

func _on_Spider_Boss_Entrance_body_entered(body):
	if body.name == "Player":
		left_bound.set_deferred("disabled", false)
		EventBus.emit_signal("boss_picked", "Spider")
		left_entrance.queue_free()

func _on_Rock_Head_Entrance_body_entered(body):
	if body.name == "Player":
		right_bound.set_deferred("disabled", false)
		EventBus.emit_signal("boss_picked", "Rock Head")
		right_entrance.queue_free()
