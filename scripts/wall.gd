extends Node2D

func _ready():
	if $Area2D/CollisionShape2D:
		$Area2D/CollisionShape2D.add_to_group("collision_shapes")

	# Debug print to ensure everything is aligned
	if $Sprite2D.texture:
		print("Texture size:", $Sprite2D.texture.get_size())
	print("Sprite position:", $Sprite2D.position)
	print("Sprite scale:", $Sprite2D.scale)

	scale = Vector2(1, 1)
