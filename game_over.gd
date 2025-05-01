extends PopupPanel

@onready var message_label = $VBoxContainer/Label
@onready var restart_button = $VBoxContainer/Restart
@onready var quit_button = $VBoxContainer/Quit

func _ready():
	# Connect button signals
	restart_button.pressed.connect(_on_restart_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_restart_pressed():
	get_tree().reload_current_scene()

func _on_quit_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func show_message(message: String):
	message_label.text = message
	popup_centered()
