extends Node2D


var test = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(test >= 200):
		$".".position = $"../Sprite2D".position
		test = -200000000
	test += 1
	
	
		
