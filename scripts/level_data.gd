extends Node

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

func get_levels() -> Array:
	return levels
