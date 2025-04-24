extends Control

@onready var toolbar = $Toolbar
@onready var coordinates_display = $CoordinatesDisplay
@onready var existing_entities = $ExistingEntities
@onready var editor_toolbox = $EditorToolbox
@onready var object_container = $WorkspaceWrapper/ObjectContainer
@onready var selection = $Selection
@onready var drop_area = $DropArea


var current_entity_scene: PackedScene = null
var preview_instance: Node2D = null

func _ready():
	# Toolbar signals
	toolbar.action_requested.connect(_on_toolbar_action)
	toolbar.grid_toggled.connect(_on_grid_toggle)
	toolbar.level_name_changed.connect(_on_level_name_changed)

	# Existing Entities selection
	existing_entities.entity_selected.connect(coordinates_display.set_selected_node)

	# Toolbox signals
	editor_toolbox.entity_selected.connect(Callable(self, "_on_entity_selected"))
	editor_toolbox.mode_changed.connect(_on_mode_changed)
	
	object_container.z_index = -1  # if Control-based



func _on_toolbar_action(action: String):
	print("Toolbar action requested:", action)

func _on_grid_toggle(is_visible: bool):
	print("Grid visibility set to:", is_visible)

func _on_level_name_changed(name: String):
	print("Level name changed to:", name)

func _on_entity_selected(scene_path: String):
	print("Spawning preview for:", scene_path)

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

	# Make sure it's visible
	preview_instance.modulate = Color(1, 1, 1, 1)  # Opaque
	object_container.add_child(preview_instance)

	print("Preview added:", preview_instance.name)
	print("Children in container:", object_container.get_child_count())

func _on_mode_changed(mode: String):
	print("Editor mode changed to:", mode)

func _process(delta):
	if preview_instance:
		var mouse_pos = get_global_mouse_position()
		preview_instance.global_position = mouse_pos
		# print("Preview position updated to:", mouse_pos)

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos = get_global_mouse_position()
		if drop_area.get_global_rect().has_point(mouse_pos):
			if preview_instance and current_entity_scene:
				print("Placing entity at:", mouse_pos)
				var placed = current_entity_scene.instantiate()
				placed.global_position = mouse_pos
				object_container.add_child(placed)


			# Optionally remove preview so it doesn't stay active
			# preview_instance.queue_free()
			# preview_instance = null
