extends Area2D

func _on_body_entered(body: Node2D) -> void:
	#Kian/EJ This is when the puck scores a goal
	#This is where you will implement going to a goal menu  
	print("GOAl")
	Global.score = 0
	get_tree().reload_current_scene()
