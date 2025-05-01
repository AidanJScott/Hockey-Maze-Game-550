extends Node2D

@onready var body := $RigidBody2D
@onready var arrow := $RigidBody2D/Sprite2D2

func _ready():
	if Engine.is_editor_hint():
		if body:
			body.is_editor_mode = true
			body.freeze = true
		if arrow:
			arrow.visible = false
	else:
		if body:
			body.is_editor_mode = false
			body.freeze = false
		if arrow:
			arrow.visible = true
