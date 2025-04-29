extends Area2D

@onready var timer = $timer

func _on_body_entered(body: Node2D) -> void:
	print("you died lol")
	Global.score = 0
	#for kian/ej this is the command that reloads the scene
	#Make this code take you to a exit/restart meny
	get_tree().reload_current_scene()
	
#func _on_timer_timeout():
	#get_tree().reload_current_scene()
