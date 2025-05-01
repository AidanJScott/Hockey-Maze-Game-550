extends Control

signal mode_changed(mode: String)
signal entity_selected(scene_path: String)

enum Mode { ADD, EDIT, DELETE, SELECT }
var current_mode: Mode = Mode.SELECT

@onready var add_button = $AddButton
@onready var entity_dropdown = $EntityDropdown
@onready var edit_button = $EditButton
@onready var delete_button = $DeleteButton
@onready var select_button = $SelectButton

var entity_scene_paths = {
	"WALL": "res://scenes/WALL.tscn",
	"GOAL": "res://scenes/goal.tscn",
	"ENEMY": "res://scenes/enemy.tscn",
	"PUCK": "res://scenes/puck_editor.tscn"  # ← Added puck here
}

func _ready():
	add_button.pressed.connect(Callable(self, "_on_add_pressed"))
	edit_button.pressed.connect(Callable(self, "_on_edit_pressed"))
	delete_button.pressed.connect(Callable(self, "_on_delete_pressed"))
	select_button.pressed.connect(Callable(self, "_on_select_pressed"))
	entity_dropdown.item_selected.connect(Callable(self, "_on_entity_selected"))

	entity_dropdown.visible = false  # Start hidden
	_update_entity_dropdown()

func _on_add_pressed():
	print("ADD BUTTON PRESSED!") 
	current_mode = Mode.ADD
	emit_signal("mode_changed", "add")
	entity_dropdown.visible = true
	_update_entity_dropdown()
	entity_dropdown.select(-1)

func _on_edit_pressed():
	current_mode = Mode.EDIT
	emit_signal("mode_changed", "edit")
	entity_dropdown.visible = false

func _on_delete_pressed():
	current_mode = Mode.DELETE
	emit_signal("mode_changed", "delete")
	entity_dropdown.visible = false

func _on_select_pressed():
	current_mode = Mode.SELECT
	emit_signal("mode_changed", "select")
	entity_dropdown.visible = false

func _update_entity_dropdown():
	entity_dropdown.clear()
	for key in entity_scene_paths.keys():
		entity_dropdown.add_item(key)

func _on_entity_selected(index: int):
	var key = entity_dropdown.get_item_text(index)
	if entity_scene_paths.has(key):
		var path = entity_scene_paths[key]
		emit_signal("entity_selected", path)
