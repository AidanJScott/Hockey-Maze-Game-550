extends Area2D

func _ready():
	collision_layer = 4  # I'm a goal
	collision_mask = 1   # I want to detect the puck
	add_to_group("goal")  # Optional, for clarity or future use

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("puck"):
		print("🥅 GOAL by:", body.name)
		# Kian/EJ: this is where goal logic or scene transition can go
		get_tree().reload_current_scene()
