extends Control

@onready var x_spinbox = $XSpinBox
@onready var y_spinbox = $YSpinBox
@onready var rotation_spinbox = $RotationSpinBox
@onready var length_spinbox = $LengthSpinBox

var selected_node: Node2D = null

func _ready():
	x_spinbox.value_changed.connect(_on_x_changed)
	y_spinbox.value_changed.connect(_on_y_changed)
	rotation_spinbox.value_changed.connect(_on_rotation_changed)
	length_spinbox.value_changed.connect(_on_length_changed)

func set_selected_node(node: Node2D):
	selected_node = node
	if node:
		x_spinbox.value = node.position.x
		y_spinbox.value = node.position.y
		rotation_spinbox.value = node.rotation_degrees
		if node.has_method("get_length"):
			length_spinbox.value = node.get_length()
		else:
			length_spinbox.editable = false
	else:
		# Disable UI if nothing is selected
		x_spinbox.editable = false
		y_spinbox.editable = false
		rotation_spinbox.editable = false
		length_spinbox.editable = false

func _on_x_changed(value):
	if selected_node:
		selected_node.position.x = value

func _on_y_changed(value):
	if selected_node:
		selected_node.position.y = value

func _on_rotation_changed(value):
	if selected_node:
		selected_node.rotation_degrees = value

func _on_length_changed(value):
	if selected_node and selected_node.has_method("set_length"):
		selected_node.set_length(value)
