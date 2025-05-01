extends Node2D

@onready var timer = $timer
@onready var body := $Area2D  # or $StaticBody2D if that’s what you're using

func _on_body_entered(body: Node2D) -> void:
	print("BODY ENTERED:", body)
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
	body.collision_layer = 2
	body.collision_mask = 1
	# Optional debug print
	print("Enemy collision layer/mask set")
	
