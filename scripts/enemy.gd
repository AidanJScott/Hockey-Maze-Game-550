extends Area2D

@onready var timer := $timer
@onready var sprite := $Sprite2D  # optional, only if you use it

func _ready():
	collision_layer = 2
	collision_mask = 1
	add_to_group("enemy")

	if sprite and sprite.texture:
		print("Texture size:", sprite.texture.get_size())
		print("Sprite position:", sprite.position)
		print("Sprite scale:", sprite.scale)

	print("✅ Enemy collision layer/mask set")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("puck"):
		print("🎯 Puck hit enemy:", body.name)
		get_tree().reload_current_scene()
