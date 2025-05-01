extends Area2D

signal goal_scored

func _ready():
	self.body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	#Kian/EJ This is when the puck scores a goal
	#This is where you will implement going to a goal menu  
	if body.name == "puck":
		print("Goal scored!")
		var popup_scene = preload("res://scenes/GameOverPopup.tscn")
		var popup = popup_scene.instantiate()
		get_tree().get_root().add_child(popup) # Adjust to your actual path
		popup.show_message("You Win!")
