extends Sprite2D



func _process(delta: float) -> void:
	self.look_at(get_global_mouse_position())
	self.rotate(PI/2)
