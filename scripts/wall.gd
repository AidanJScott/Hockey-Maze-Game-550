extends Node2D

func _ready():
	# Assign the wall's collision to Layer 3, detect Layer 1 (puck)
	if $Area2D:
		$Area2D.collision_layer = 3
		$Area2D.collision_mask = 1

	# Group the collision shape for selection in the editor
	if $Area2D/CollisionShape2D:
		$Area2D/CollisionShape2D.add_to_group("collision_shapes")

	# Debug info
	if $Sprite2D.texture:
		print("Texture size:", $Sprite2D.texture.get_size())
	print("Sprite position:", $Sprite2D.position)
	print("Sprite scale:", $Sprite2D.scale)

	scale = Vector2(1, 1)
