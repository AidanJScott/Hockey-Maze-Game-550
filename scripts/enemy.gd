extends Node2D

@onready var timer = $timer

func _ready():
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	print("you died lol")
	Global.score = 0
	#for kian/ej this is the command that reloads the scene
	#Make this code take you to a exit/restart meny
	if body.name == "puck":
		var popup_scene = preload("res://scenes/gameOverPopup.tscn") 
		var popup = popup_scene.instantiate()
		get_tree().get_root().add_child(popup)# Adjust path as needed
		popup.show_message("You Lose!")
	
#func _on_timer_timeout():
	#get_tree().reload_current_scene()
func _ready():
	if $Sprite2D.texture:
		print("Texture size:", $Sprite2D.texture.get_size())
	print("Sprite position:", $Sprite2D.position)
	print("Sprite scale:", $Sprite2D.scale)
	$Sprite2D.scale = Vector2(1, 1)
	scale = Vector2(1, 1)
