extends PopupPanel

@onready var message_label = $Panel/VBoxContainer/Label
@onready var restart_button = $Panel/VBoxContainer/RestartButton
@onready var quit_button = $Panel/VBoxContainer/QuitButton

func _ready():
	restart_button.pressed.connect(_on_restart_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func show_message(message: String):
	message_label.text = message
	visible = true
	popup_centered()

func _on_restart_pressed():
	get_tree().paused = false
	queue_free()
	get_tree().reload_current_scene()

func _on_quit_pressed():
	get_tree().paused = false
	queue_free()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
