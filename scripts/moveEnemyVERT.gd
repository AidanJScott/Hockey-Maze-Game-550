extends Node2D

const SPEED = 10
var direction = 10
var upOrDown = 100
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y += direction * SPEED * delta 
	upOrDown = upOrDown + 1
	if upOrDown >= 200:
		upOrDown = 0
		direction = -10
	if upOrDown == 100:
		direction = 10
	
