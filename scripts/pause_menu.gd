extends Control

@onready var resume_button = $Panel/HBoxContainer/VBoxContainer/ResumeButton
@onready var main_menu_button = $Panel/HBoxContainer/VBoxContainer/MainMenu

func _ready():
	print("✅ ResumeButton:", resume_button)
	print("✅ MainMenuButton:", main_menu_button)

	if resume_button:
		resume_button.pressed.connect(_on_resume_pressed)
	else:
		print("❌ ResumeButton not found!")

	if main_menu_button:
		main_menu_button.pressed.connect(_on_quit_pressed)
	else:
		print("❌ MainMenuButton not found!")

func _on_resume_pressed():
	PauseMenuManager.hide_pause_menu()

func _on_quit_pressed():
	PauseMenuManager.hide_pause_menu()  # 🧹 Make sure to remove/hide the pause menu
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
