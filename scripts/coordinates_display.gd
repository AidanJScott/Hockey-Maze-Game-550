extends Control

@onready var title_label = $VBoxContainer/TitleLabel
@onready var position_label = $VBoxContainer/PositionLabel
@onready var size_label = $VBoxContainer/SizeLabel

var selected_node: Node2D = null
var placing_type: String = ""  # Tracks what the user is currently placing

func _process(_delta):
	if selected_node and selected_node.is_inside_tree():
		var pos = selected_node.global_position
		position_label.text = "Position\nX: %.0f\nY: %.0f" % [pos.x, pos.y]

		var size = Vector2.ZERO
		if selected_node.has_method("get_rect"):
			size = selected_node.get_rect().size
		elif selected_node.has_method("get_size"):
			size = selected_node.get_size()
		size_label.text = "Size\nW: %.0f\nH: %.0f" % [size.x, size.y]

		title_label.text = "Selected: " + selected_node.name
	else:
		var mouse_pos = get_viewport().get_mouse_position()
		if placing_type != "":
			title_label.text = "Placing: " + placing_type
		else:
			title_label.text = "No Object Selected"
		position_label.text = "Mouse\nX: %.0f\nY: %.0f" % [mouse_pos.x, mouse_pos.y]
		size_label.text = "Size: -"

func set_selected_node(node: Node2D):
	selected_node = node

func clear_selection():
	selected_node = null

func set_placing_type(name: String):
	placing_type = name
