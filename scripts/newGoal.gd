extends Area2D
@onready var yippee = $goalfz

func _on_body_entered(body: Node2D) -> void:
	#Kian/EJ This is when the puck scores a goal
	#This is where you will implement going to a goal menu  
	print("GOAl")
	Global.score = 0
	yippee.play()
	$Timer.start()
	
	


func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
