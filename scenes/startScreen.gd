extends Control

@onready var start_option_button = $CenterContainer/VBoxContainer/StartOptionButton

var LevelData = preload("res://scripts/level_data.gd").new()
var levels = LevelData.get_levels()



func _ready():
	# Add menu items dynamically (optional, or use the Inspector)
	start_option_button.clear()
	start_option_button.add_item("Click to start")  # index 0
	for level in levels:
		start_option_button.add_item(level["name"])
	start_option_button.add_item("Quit")

	start_option_button.item_selected.connect(_on_option_selected)

func _on_option_selected(index):
	if index == 0:
		return # Placeholder, do nothing

	elif index >= 1 and index <= levels.size():
		var selected_level = levels[index - 1]
		if selected_level["path"] != null:
			get_tree().change_scene_to_file(selected_level["path"])
		else:
			print("Level path is missing!")

	elif index == levels.size() + 1:
		get_tree().change_scene_to_file("res://scenes/levelEditor.tscn")

	elif index == levels.size() + 2:
		get_tree().change_scene_to_file("res://scenes/levelEditorMenu.tscn")
