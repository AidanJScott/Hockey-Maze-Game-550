extends Control

@onready var volume_slider = $VBoxContainer/VolumeSlider
@onready var level_selector_button = $VBoxContainer/LevelSelectorButton
@onready var level_editor_button = $VBoxContainer/LevelEditorButton
@onready var quit_button = $VBoxContainer/QuitButton

func _ready():
	# Set volume slider to current volume from autoload
	volume_slider.value = settings.get_volume()
	
	# Connect signals for buttons
	volume_slider.connect("value_changed", Callable(self, "_on_volume_changed"))
	level_selector_button.connect("pressed", Callable(self, "_on_level_selector_pressed"))
	level_editor_button.connect("pressed", Callable(self, "_on_level_editor_pressed"))
	quit_button.connect("pressed", Callable(self, "_on_quit_pressed"))

func _on_volume_changed(value):
	settings.set_volume(value)

func _on_level_selector_pressed():
	get_tree().change_scene_to_file("res://scenes/level_selector.tscn")

func _on_level_editor_pressed():
	get_tree().change_scene_to_file("res://scenes/level_editor.tscn")

func _on_quit_pressed():
	get_tree().quit()
