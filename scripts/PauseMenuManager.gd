extends Node


var pause_menu_scene = preload("res://ui/pause_menu.tscn")
var pause_menu_instance: CanvasLayer

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
