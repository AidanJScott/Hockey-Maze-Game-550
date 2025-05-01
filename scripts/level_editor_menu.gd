# LevelEditorMenu.gd
extends Control

@onready var level_list = $VBoxContainer/LevelList
@onready var load_button = $VBoxContainer/HBoxContainer/LoadButton
@onready var new_button = $VBoxContainer/HBoxContainer/NewLevelButton
@onready var delete_button = $VBoxContainer/HBoxContainer/DeleteButton
@onready var back_button = $VBoxContainer/HBoxContainer/BackButton

signal level_selected(level_name: String)

func _ready():
	populate_level_list()
	load_button.pressed.connect(_on_load_pressed)
	new_button.pressed.connect(_on_new_level_pressed)
	back_button.pressed.connect(_on_back_pressed)

func populate_level_list():
	level_list.clear()
	var dir = DirAccess.open("user://levels")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".json"):
				level_list.add_item(file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("Failed to open user://levels")

func _on_load_pressed():
	if level_list.get_selected_items().size() > 0:
		var selected_file = level_list.get_item_text(level_list.get_selected_items()[0])
		
		LevelEditorLoader.selected_level_name = selected_file  # ✅ Store for LevelEditor
		get_tree().change_scene_to_file("res://scenes/levelEditor.tscn")  # ✅ Load editor
	else:
		print("No level selected")

func _on_new_level_pressed():
	LevelEditorLoader.selected_level_name = ""  # ✅ Blank name = new level
	get_tree().change_scene_to_file("res://scenes/levelEditor.tscn")


func _on_delete_pressed():
	if level_list.get_selected_items().size() > 0:
		var selected_file = level_list.get_item_text(level_list.get_selected_items()[0])
		var full_path = "user://levels/" + selected_file
		var dir = DirAccess.open("user://levels")
		if dir and dir.file_exists(selected_file):
			var error = dir.remove(selected_file)
			if error == OK:
				print("Deleted level:", selected_file)
			else:
				print("Failed to delete:", selected_file, "Error code:", error)
			populate_level_list()
	else:
		print("No level selected to delete")
		
func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/startScreen.tscn")
