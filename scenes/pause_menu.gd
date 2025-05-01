extends Node2D



func _ready():
	$ResumeButton.connect("pressed", _on_resume_pressed)
	$QuitToMainMenuButton.connect("pressed", _on_quit_pressed)

func _on_resume_pressed():
	PauseMenuManager.hide_pause_menu()

func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
