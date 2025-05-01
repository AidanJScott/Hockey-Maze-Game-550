extends Node2D

@onready var level_objects := $LevelObjects
@onready var puck := $Puck

func _ready():
	if LevelEditorLoader.selected_level_name != "":
		load_level(LevelEditorLoader.selected_level_name.get_basename())

func load_level(name: String):
	var file = FileAccess.open("user://levels/" + name + ".json", FileAccess.READ)
	if not file:
		print("Failed to load level file:", name)
		return

	var data = JSON.parse_string(file.get_as_text())
	if typeof(data) != TYPE_DICTIONARY:
		print("Invalid level data format.")
		return

	for entity in data["entities"]:
		var scene = load(entity["scene_path"])
		if scene:
			var instance = scene.instantiate()
			instance.global_position = str_to_var(entity["position"])
			instance.scale = str_to_var(entity["scale"])
			instance.rotation = float(entity["rotation"])
			level_objects.add_child(instance)
