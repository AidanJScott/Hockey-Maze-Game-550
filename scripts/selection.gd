extends Control

@onready var scale_x_spinbox = $VBoxContainer/ScaleSizeXSpinBox
@onready var scale_y_spinbox = $VBoxContainer/ScaleSizeYSpinBox
@onready var rotation_spinbox = $VBoxContainer/RotationSpinBox
@onready var x_spinbox = $VBoxContainer/XCoordinateSpinBox
@onready var y_spinbox = $VBoxContainer/YCoordinateSpinBox

var selected_node: Node2D = null
var suppress_signals := false

func _ready():
	scale_x_spinbox.value_changed.connect(_on_scale_x_changed)
	scale_y_spinbox.value_changed.connect(_on_scale_y_changed)
	rotation_spinbox.value_changed.connect(_on_rotation_changed)
	x_spinbox.value_changed.connect(_on_x_changed)
	y_spinbox.value_changed.connect(_on_y_changed)

func set_selected_node(node: Node2D):
	selected_node = node

	suppress_signals = true  # Temporarily ignore changes during setup

	if node and node.is_inside_tree():
		scale_x_spinbox.editable = true
		scale_y_spinbox.editable = true
		rotation_spinbox.editable = true
		x_spinbox.editable = true
		y_spinbox.editable = true

		scale_x_spinbox.value = node.scale.x
		scale_y_spinbox.value = node.scale.y
		rotation_spinbox.value = node.rotation_degrees
		x_spinbox.value = node.position.x
		y_spinbox.value = node.position.y
	else:
		scale_x_spinbox.editable = false
		scale_y_spinbox.editable = false
		rotation_spinbox.editable = false
		x_spinbox.editable = false
		y_spinbox.editable = false
		_clear_spinboxes()

	suppress_signals = false

func _clear_spinboxes():
	scale_x_spinbox.value = 1
	scale_y_spinbox.value = 1
	rotation_spinbox.value = 0
	x_spinbox.value = 0
	y_spinbox.value = 0

func _on_scale_x_changed(value):
	if selected_node and not suppress_signals:
		selected_node.scale.x = value

func _on_scale_y_changed(value):
	if selected_node and not suppress_signals:
		selected_node.scale.y = value

func _on_rotation_changed(value):
	if selected_node and not suppress_signals:
		selected_node.rotation_degrees = value

func _on_x_changed(value):
	if selected_node and not suppress_signals:
		var bounds = get_viewport().get_node("LevelEditor/DropArea").get_global_rect()  # Adjust path if needed
		value = clamp(value, bounds.position.x, bounds.position.x + bounds.size.x)
		selected_node.position.x = value

func _on_y_changed(value):
	if selected_node and not suppress_signals:
		var bounds = get_viewport().get_node("LevelEditor/DropArea").get_global_rect()  # Adjust path if needed
		value = clamp(value, bounds.position.y, bounds.position.y + bounds.size.y)
		selected_node.position.y = value
