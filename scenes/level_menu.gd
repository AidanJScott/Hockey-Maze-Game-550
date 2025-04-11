extends Control 

#The levels would probably fit better it a script with static data and then add to it using the methods.
var levels = [
	{"path": "", "name": "Placeholder Level 1"},
	{"path": "", "name": "Placeholder Level 2"},
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
	button.connect("pressed", Callable(self, "_on_level_selected").bind(level.id))
	container.add_child(button)

func _on_level_selected(level_id):
	print("Selected Level:", level_id)
	

func get_levels():
	return levels

func add_level(level_name):
	var new_id = levels.size() + 1
	var new_level = {"id": new_id, "name": level_name}
	levels.append(new_level)
	add_level_button(new_level) 
