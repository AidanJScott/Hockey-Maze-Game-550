extends Control

@onready var settings_menu = $VBoxContainer/Settings
@onready var settings_popup = $SettingsPopup

@onready var level_selector = $VBoxContainer/LevelSelector
@onready var level_editor_button = $VBoxContainer/LevelEditorButton
@onready var quit_button = $VBoxContainer/QuitButton

func _ready():
	# Populate the OptionButton with dummy levels
	level_selector.add_item("Level 1")
	level_selector.add_item("Level 2")
	level_selector.add_item("Level 3")
	#use get the levels array from level selector and iterate throught them and add

	level_selector.connect("item_selected", _on_level_selected)
	settings_menu.get_popup().connect("id_pressed", _on_settings_menu_selected)
	level_editor_button.connect("pressed", _on_level_editor_pressed)
	quit_button.connect("pressed", _on_quit_pressed)

func _on_volume_changed(value):
	Settings.set_volume(value)

func _on_level_selected(index):
	var level_name = level_selector.get_item_text(index)
	print("Selected level: ", level_name)
	# Later: get_tree().change_scene_to_file(...) with actual level

func _on_settings_menu_selected(id):
	# Just one option for now
	if id == 0:
		settings_popup.popup_centered()

func _on_level_editor_pressed():
	get_tree().change_scene_to_file("res://scenes/level_editor.tscn")

func _on_quit_pressed():
	get_tree().quit()
