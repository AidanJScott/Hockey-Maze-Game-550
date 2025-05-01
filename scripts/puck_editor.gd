extends Node2D

func _ready():
	# You can optionally set visual indicators only when in editor
	if Engine.is_editor_hint():
		modulate = Color(1, 1, 1, 1)  # Fully visible in editor
	else:
		# This is where you'd enable puck logic in gameplay if needed
		pass
