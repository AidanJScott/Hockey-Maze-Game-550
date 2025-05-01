extends Control

@onready var toolbar = $Toolbar
@onready var coordinates_display = $CoordinatesDisplay
@onready var existing_entities = $ExistingEntities
@onready var editor_toolbox = $EditorToolbox
@onready var object_container = $WorkspaceWrapper/ObjectContainer
@onready var selection = $SelectionBox
@onready var drop_area = $DropArea
@onready var draw_overlay = $DropArea/DrawOverlay

var current_entity_scene: PackedScene = null
var preview_instance: Node2D = null
var current_mode: String = "select"
var dragged_node: Node2D = null
var is_dragging: bool = false
var drag_offset := Vector2.ZERO

var is_grid_enabled: bool = false
const GRID_SIZE := 32

var entity_scales = {
	"WALL": Vector2(2, 2),
	"GOAL": Vector2(0.6, 0.6),
	"ENEMY": Vector2(10, 10),
	"PUCK": Vector2(0.5, 0.5)
}

var undo_stack: Array = []
var redo_stack: Array = []
var current_level_name: String = ""

func _ready():
	await get_tree().process_frame

	toolbar.action_requested.connect(_on_toolbar_action)
	toolbar.grid_toggled.connect(_on_grid_toggle)
	toolbar.level_name_changed.connect(_on_level_name_changed)

	existing_entities.entity_selected.connect(coordinates_display.set_selected_node)
	existing_entities.entity_selected.connect(selection.set_selected_node)

	editor_toolbox.entity_selected.connect(_on_entity_selected)
	editor_toolbox.mode_changed.connect(_on_mode_changed)

	object_container.z_index = -1
	draw_overlay.z_index = 1000
	draw_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	draw_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var name = LevelEditorLoader.selected_level_name
	if name != "":
		toolbar.level_name_input.text = name.get_basename()
		load_level(name.get_basename())

func _on_toolbar_action(action: String):
	match action:
		"undo": undo_last()
		"redo": redo_last()
		"clear": clear_level()
		"save":
			if current_level_name != "":
				save_level(current_level_name)
			else:
				print("No level name to save")
		"back":
			get_tree().change_scene_to_file("res://scenes/levelEditorMenu.tscn")
		_:
			print("Toolbar action requested:", action)

func _on_grid_toggle(is_visible: bool):
	is_grid_enabled = is_visible
	draw_overlay.visible = is_grid_enabled
	draw_overlay.queue_redraw()
	print("Grid snapping:", is_grid_enabled)

func _on_level_name_changed(name: String):
	current_level_name = name
	print("Level name changed to:", name)

func _on_entity_selected(scene_path: String):
	print("Spawning preview for:", scene_path)
	print("Key detected:", get_entity_key_from_path(scene_path))

	current_entity_scene = load(scene_path)
	if not current_entity_scene:
		print("Failed to load scene at:", scene_path)
		return

	if preview_instance:
		preview_instance.queue_free()

	preview_instance = current_entity_scene.instantiate()
	if not preview_instance:
		print("Failed to instantiate scene.")
		return

	var key_name = get_entity_key_from_path(scene_path)
	if entity_scales.has(key_name):
		preview_instance.scale = entity_scales[key_name]
		
	coordinates_display.set_placing_type(key_name)
	preview_instance.modulate = Color(1, 1, 1, 1)
	object_container.add_child(preview_instance)

func _on_mode_changed(mode: String):
	print("Editor mode changed to:", mode)
	current_mode = mode

	if mode != "add" and preview_instance:
		preview_instance.queue_free()
		preview_instance = null

func _process(delta):
	draw_overlay.queue_redraw()

	var mouse_pos = get_global_mouse_position()

	if preview_instance:
		var new_pos = mouse_pos + drag_offset
		if is_grid_enabled:
			new_pos = Vector2(Vector2i(new_pos / GRID_SIZE) * GRID_SIZE) - drag_offset
		preview_instance.global_position = clamp_position_to_drop_area(new_pos, preview_instance)
	elif is_dragging and dragged_node:
		if not is_mouse_inside_drop_area():
			return

		var new_pos = mouse_pos + drag_offset
		if is_grid_enabled:
			new_pos = Vector2(Vector2i(new_pos / GRID_SIZE) * GRID_SIZE)
		dragged_node.global_position = clamp_position_to_drop_area(new_pos, dragged_node)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos = get_global_mouse_position()
		if event.pressed:
			if current_mode == "add" and drop_area.get_global_rect().has_point(mouse_pos):
				if preview_instance and current_entity_scene:
					var key_name = get_entity_key_from_path(current_entity_scene.resource_path)

					if key_name == "PUCK":
						for child in object_container.get_children():
							if child == preview_instance:
								continue  # Ignore the preview
							if child.is_in_group("puck"):
								print("⚠️ A puck is already placed. Skipping.")
								return

					var placed = current_entity_scene.instantiate()
					placed.global_position = preview_instance.global_position

					if key_name == "PUCK":
						placed.add_to_group("puck")

					if is_grid_enabled:
						placed.global_position = Vector2(Vector2i(placed.global_position / GRID_SIZE) * GRID_SIZE)

					if entity_scales.has(key_name):
						placed.scale = entity_scales[key_name]

					object_container.add_child(placed)

					for shape in placed.get_tree().get_nodes_in_group("collision_shapes"):
						if shape is CollisionShape2D:
							shape.disabled = false

					existing_entities.add_entity(placed)

					undo_stack.append({
						"scene_path": current_entity_scene.resource_path,
						"position": placed.global_position,
						"scale": placed.scale,
						"node": placed
					})
					redo_stack.clear()
					print("✅ Entity placed:", key_name)
			elif current_mode in ["select", "edit", "delete"]:
				is_dragging = false
				dragged_node = null

				for child in object_container.get_children():
					print("🔍 Checking child:", child.name)
					if child is Node2D or child is StaticBody2D:
						var shape_nodes = child.get_tree().get_nodes_in_group("collision_shapes")
						for shape_node in shape_nodes:
							if not shape_node.is_inside_tree() or not child.is_ancestor_of(shape_node):
								continue
							if shape_node.disabled or shape_node.shape == null:
								continue

							var shape = shape_node.shape
							var local_mouse_pos = shape_node.get_global_transform().affine_inverse() * mouse_pos
							var hit := false

							if shape is RectangleShape2D:
								hit = Rect2(-shape.size / 2.0, shape.size).has_point(local_mouse_pos)
							elif shape is CircleShape2D:
								hit = local_mouse_pos.length() <= shape.radius

							if hit:
								print("🎯 Hit:", child.name)
								if current_mode == "delete":
									child.queue_free()
									existing_entities.remove_entity(child)
								else:
									selection.set_selected_node(child)
									dragged_node = child
									is_dragging = true
									drag_offset = dragged_node.global_position - mouse_pos
								break
					if is_dragging:
						break
		else:
			if is_dragging:
				if is_grid_enabled and dragged_node:
					var pos = dragged_node.global_position
					pos = Vector2(Vector2i(pos / GRID_SIZE) * GRID_SIZE)
					dragged_node.global_position = clamp_position_to_drop_area(pos, dragged_node)
				is_dragging = false
				dragged_node = null

func undo_last():
	if undo_stack.size() > 0:
		var last = undo_stack.pop_back()
		var node = last.get("node", null)
		if node and node.is_inside_tree():
			node.queue_free()
			existing_entities.remove_entity(node)
		redo_stack.append(last)

func redo_last():
	if redo_stack.size() > 0:
		var data = redo_stack.pop_back()
		var scene = load(data["scene_path"])
		if scene:
			var node = scene.instantiate()
			node.global_position = data["position"]
			node.scale = data["scale"]
			object_container.add_child(node)
			existing_entities.add_entity(node)
			data["node"] = node
			undo_stack.append(data)

func clear_level():
	for child in object_container.get_children():
		child.queue_free()
	undo_stack.clear()
	redo_stack.clear()
	existing_entities.clear_entities()

func get_entity_key_from_path(path: String) -> String:
	path = path.to_lower()
	if "puck" in path:
		return "PUCK"
	if "lowqualitywall" in path or "wall" in path:
		return "WALL"
	if "goal" in path:
		return "GOAL"
	if "enemy" in path:
		return "ENEMY"
	return "WALL"

func is_mouse_inside_drop_area() -> bool:
	return drop_area.get_global_rect().has_point(get_global_mouse_position())

func save_level(name: String):
	var level_data = { "entities": [] }

	for child in object_container.get_children():
		if child is Node2D:
			var data = {
				"scene_path": child.scene_file_path,
				"position": [child.global_position.x, child.global_position.y],
				"scale": [child.scale.x, child.scale.y],
				"rotation": child.rotation
			}
			level_data["entities"].append(data)

	var dir = "user://levels"
	if not DirAccess.dir_exists_absolute(dir):
		DirAccess.make_dir_absolute(dir)

	var file = FileAccess.open(dir + "/" + name + ".json", FileAccess.WRITE)
	file.store_string(JSON.stringify(level_data, "\t"))
	file.close()
	print("Level saved to:", dir + "/" + name + ".json")

func load_level(name: String):
	clear_level()

	var file = FileAccess.open("user://levels/" + name + ".json", FileAccess.READ)
	if not file:
		print("Failed to open file.")
		return

	var text = file.get_as_text()
	var result = JSON.parse_string(text)
	if typeof(result) != TYPE_DICTIONARY:
		print("Invalid JSON format.")
		return

	for entity in result["entities"]:
		var scene = load(entity["scene_path"])
		if scene:
			var instance = scene.instantiate()
			var pos = Vector2(entity["position"][0], entity["position"][1])
			var scale = Vector2(entity["scale"][0], entity["scale"][1])
			var rotation = float(entity["rotation"])

			instance.global_position = pos
			instance.scale = scale
			instance.rotation = rotation

			object_container.add_child(instance)
			existing_entities.add_entity(instance)

func clamp_position_to_drop_area(pos: Vector2, node: Node2D) -> Vector2:
	var bounds = drop_area.get_global_rect()

	var extents = Vector2(0, 0)
	var shapes = node.get_tree().get_nodes_in_group("collision_shapes")

	for shape_node in shapes:
		if shape_node is CollisionShape2D and shape_node.shape:
			var shape = shape_node.shape
			if shape is RectangleShape2D:
				var size = shape.size * node.scale
				extents = size / 2.0
			elif shape is CircleShape2D:
				var r = shape.radius * max(node.scale.x, node.scale.y)
				extents = Vector2(r, r)

	pos.x = clamp(pos.x, bounds.position.x + extents.x, bounds.end.x - extents.x)
	pos.y = clamp(pos.y, bounds.position.y + extents.y, bounds.end.y - extents.y)

	return pos
