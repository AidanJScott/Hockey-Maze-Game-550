extends Area2D

func _ready():
	collision_layer = 2
	collision_mask = 1
	add_to_group("enemy")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("puck"):
		print("🎯 Puck hit by enemy:", body.name)
		get_tree().reload_current_scene()
