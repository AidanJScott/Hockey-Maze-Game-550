extends PopupPanel

@onready var message_label = $Label

# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.connect("pressed", Callable(self, "_on_restart_pressed"))
	$Button2.connect("pressed", Callable(self, "_on_quit_pressed"))

func _on_restart_pressed():
	get_tree().reload_current_scene()

func _on_quit_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func show_message(message: String):
	message_label.text = message
	visible = true
	popup_centered()
