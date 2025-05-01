extends Area2D

func _ready():
	collision_layer = 2
	collision_mask = 1
	add_to_group("enemy")

func _on_body_entered(body: Node2D):
	if body.is_in_group("puck"):
		print("💀 Puck died to enemy")
		var game_over_ui = preload("res://scenes/gameOverPopup.tscn").instantiate()
		get_tree().root.add_child(game_over_ui)
		game_over_ui.show_message("💀 Game Over")
		get_tree().paused = true
