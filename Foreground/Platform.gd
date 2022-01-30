extends Node2D


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.position = Vector2(body.position.x, body.position.y + 1)
