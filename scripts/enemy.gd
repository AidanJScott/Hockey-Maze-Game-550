extends Node2D

@onready var timer = $timer

func _on_body_entered(body: Node2D) -> void:
	print("you died lol")
	#for kian/ej this is the command that reloads the scene
	#Make this code take you to a exit/restart meny
	get_tree().reload_current_scene()
	
#func _on_timer_timeout():
	#get_tree().reload_current_scene()
func _ready():
	if $Sprite2D.texture:
		print("Texture size:", $Sprite2D.texture.get_size())
	print("Sprite position:", $Sprite2D.position)
	print("Sprite scale:", $Sprite2D.scale)
	$Sprite2D.scale = Vector2(1, 1)
	scale = Vector2(1, 1)
