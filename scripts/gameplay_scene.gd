extends Node2D

@onready var level_objects := $LevelObjects
# @onready var puck := $Puck  # You can remove this node if it's no longer used in the scene tree

var real_puck_scene := preload("res://scenes/puck.tscn")  # Your gameplay puck (RigidBody2D)

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
		var scene_path: String = entity["scene_path"]
		var position := Vector2(entity["position"][0], entity["position"][1])
		var scale := Vector2(entity["scale"][0], entity["scale"][1])
		var rotation := float(entity["rotation"])

		if "puck" in scene_path.to_lower():
			print("🧊 Replacing editor puck with gameplay puck...")
			var puck_instance = real_puck_scene.instantiate()
			puck_instance.global_position = position
			level_objects.add_child(puck_instance)
		else:
			var scene = load(scene_path)
			if scene:
				var instance = scene.instantiate()
				instance.global_position = position
				instance.scale = scale
				instance.rotation = rotation
				level_objects.add_child(instance)
