extends Control

var levels = [
	{"path": "res://scenes/baseLevel.tscn", "name": "Base Level"},
	{"path": "res://scenes/Levels/Level2.tscn", "name": "Level 1"},
	{"path": "res://scenes/Levels/Level4.tscn", "name": "Level 2"},
	{"path": "res://scenes/Levels/Level5.tscn", "name": "Level 3"},
	{"path": "res://scenes/Levels/Level7.tscn", "name": "Level 4"},
	{"path": "res://scenes/Levels/Level8.tscn", "name": "Level 5"},
	{"path": "res://scenes/LevelEditor.tscn", "name": "Level Editor"},
	{"path": "", "name": "Placeholder Level"}
]

@onready var container = $PanelContainer/ScrollContainer/LevelGrid  # Adjust path if yours differs

func _ready():
	print("🟢 LevelSelector _ready()")
	update_level_menu()

func update_level_menu():
	print("🔄 Updating level menu")
	container.clear()
	for level in levels:
		add_level_button(level)

func add_level_button(level: Dictionary) -> void:
	var button = Button.new()
	button.text = level["name"]

	button.pressed.connect(func():
		print("➡️ Button pressed for:", level["name"], "| Path:", level["path"])
		_on_level_selected(level["path"])
	)

	container.add_child(button)
	print("✅ Added button:", level["name"])

func _on_level_selected(level_path: String) -> void:
	print("🎯 _on_level_selected() called with path:", level_path)

	if level_path == "":
		print("⚠️ No path defined. Skipping.")
		return

	if not ResourceLoader.exists(level_path):
		print("❌ Scene file does not exist at path:", level_path)
		return

	var err = get_tree().change_scene_to_file(level_path)
	if err != OK:
		print("❌ Failed to change scene! Error code:", err)
	else:
		print("✅ Scene loaded:", level_path)
