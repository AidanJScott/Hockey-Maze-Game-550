extends Node

var pause_menu_scene = preload("res://scenes/pause_menu.tscn")
var pause_menu_instance: CanvasLayer

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS  # ✅ So input works even while paused

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		if not get_tree().paused:
			show_pause_menu()
		else:
			hide_pause_menu()

func show_pause_menu():
	if not pause_menu_instance:
		pause_menu_instance = pause_menu_scene.instantiate()
		get_tree().root.add_child(pause_menu_instance)
	pause_menu_instance.visible = true
	get_tree().paused = true

func hide_pause_menu():
	if pause_menu_instance:
		pause_menu_instance.visible = false
		get_tree().paused = false
