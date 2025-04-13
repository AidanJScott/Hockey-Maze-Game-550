extends Control

@onready var toolbar = $UI/Toolbar
@onready var coordinates_display = $UI/CoordinatesDisplay
@onready var existing_entities = $UI/ExistingEntities

func _ready():
	# Toolbar signals
	toolbar.action_requested.connect(_on_toolbar_action)
	toolbar.grid_toggled.connect(_on_grid_toggle)
	toolbar.level_name_changed.connect(_on_level_name_changed)

	# ExistingEntities signals
	existing_entities.entity_selected.connect(coordinates_display.set_selected_node)

func _on_toolbar_action(action: String):
	print("Toolbar action requested:", action)

func _on_grid_toggle(is_visible: bool):
	print("Grid visibility set to:", is_visible)

func _on_level_name_changed(name: String):
	print("Level name changed to:", name)
