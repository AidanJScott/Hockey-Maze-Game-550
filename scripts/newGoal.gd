extends Area2D

@onready var yippe = $"../goalfz"
@onready var goal_timer = $"../goalTimer"  # Updated to match sibling position

func _ready():
	collision_layer = 4
	collision_mask = 1
	add_to_group("goal")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("puck"):
		print("🥅 GOAL by:", body.name)
		Global.score = 0
		yippe.play()
		var game_over_ui = preload("res://scenes/gameOverPopup.tscn").instantiate()
		get_tree().root.add_child(game_over_ui)
		game_over_ui.show_message("🎉 You Win!")
		get_tree().paused = true
		
func _on_goal_timer_timeout() -> void:
	get_tree().reload_current_scene()
