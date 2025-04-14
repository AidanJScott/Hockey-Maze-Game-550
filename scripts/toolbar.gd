# toolbar.gd
extends Control

signal action_requested(action: String)
signal grid_toggled(is_visible: bool)
signal level_name_changed(new_name: String)

@onready var back_button = $BackButton
@onready var save_button = $SaveButton
@onready var undo_button = $UndoButton
@onready var redo_button = $RedoButton
@onready var clear_button = $ClearButton
@onready var grid_toggle = $GridToggleButton
@onready var test_button = $TestButton
@onready var info_button = $InfoButton
@onready var help_button = $HelpButton
@onready var level_name_input = $LevelNameInput

func _ready():
	back_button.pressed.connect(_on_back_pressed)
	save_button.pressed.connect(_on_save_pressed)
	undo_button.pressed.connect(_on_undo_pressed)
	redo_button.pressed.connect(_on_redo_pressed)
	clear_button.pressed.connect(_on_clear_pressed)
	test_button.pressed.connect(_on_test_pressed)
	info_button.pressed.connect(_on_info_pressed)
	help_button.pressed.connect(_on_help_pressed)

	grid_toggle.toggled.connect(_on_grid_toggled)
	level_name_input.text_changed.connect(_on_level_name_changed)

func _on_grid_toggled(pressed: bool):
	emit_signal("grid_toggled", pressed)

func _on_level_name_changed(new_name: String):
	emit_signal("level_name_changed", new_name)

# ⬇️ Add these below
func _on_back_pressed():
	emit_signal("action_requested", "back")

func _on_save_pressed():
	emit_signal("action_requested", "save")

func _on_undo_pressed():
	emit_signal("action_requested", "undo")

func _on_redo_pressed():
	emit_signal("action_requested", "redo")

func _on_clear_pressed():
	emit_signal("action_requested", "clear")

func _on_test_pressed():
	emit_signal("action_requested", "test")

func _on_info_pressed():
	emit_signal("action_requested", "info")

func _on_help_pressed():
	emit_signal("action_requested", "help")
