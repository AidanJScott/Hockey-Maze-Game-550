# editor_toolbox.gd
extends Control

signal mode_changed(new_mode: String)

enum Mode { ADD, EDIT, DELETE, SELECT }
var current_mode: Mode = Mode.SELECT

@onready var add_button = $VBoxContainer/AddButton
@onready var edit_button = $VBoxContainer/EditButton
@onready var delete_button = $VBoxContainer/DeleteButton
@onready var select_button = $VBoxContainer/SelectButton

func _ready():
	add_button.pressed.connect(_on_add_pressed)
	edit_button.pressed.connect(_on_edit_pressed)
	delete_button.pressed.connect(_on_delete_pressed)
	select_button.pressed.connect(_on_select_pressed)

func _on_add_pressed():
	current_mode = Mode.ADD
	emit_signal("mode_changed", "add")

func _on_edit_pressed():
	current_mode = Mode.EDIT
	emit_signal("mode_changed", "edit")

func _on_delete_pressed():
	current_mode = Mode.DELETE
	emit_signal("mode_changed", "delete")

func _on_select_pressed():
	current_mode = Mode.SELECT
	emit_signal("mode_changed", "select")
