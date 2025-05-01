extends Control 

#The levels would probably fit better it a script with static data and then add to it using the methods.
var levels = [
	{"path": "res://scenes/baseLevel.tscn", "name": "Base Level"},
	{"path": "res://scenes/Levels/level2.tscn", "name": "Level 1"},
	{"path": "res://scenes/Levels/level4.tscn", "name": "Level 2"},
	{"path": "res://scenes/Levels/level5.tscn", "name": "Level 3"},
	{"path": "res://scenes/Levels/level7.tscn", "name": "Level 4"},
	{"path": "res://scenes/Levels/level8.tscn", "name": "Level 5"},
	{"path": "res://scenes/LevelEditor.tscn", "name": "Level Editor"},
	{"path": "", "name": "Placeholder Level 3"}
]

# singleton
@onready var container = $VBoxContainer

func _ready():
	update_level_menu()

func update_level_menu():
	container.clear()  
	for level in levels:
		add_level_button(level)

func add_level_button(level):
	var button = Button.new()
	button.text = level.name
	button.connect("pressed", Callable(self, "_on_level_selected").bind(level.path))
	container.add_child(button)

func _on_level_selected(level_id):
	for level in levels:
		get_tree().change_scene_to_file(level["path"])
		print("Selected Level:", level_id)
	

func get_levels():
	return levels

func add_level(level_name):
	var new_id = levels.size() + 1
	var new_level = {"id": new_id, "name": level_name}
	levels.append(new_level)
	add_level_button(new_level) 
