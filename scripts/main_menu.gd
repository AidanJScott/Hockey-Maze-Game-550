extends Control

@onready var settings_menu = $VBoxContainer/Settings
@onready var settings_popup = $SettingsPopup
@onready var level_selector_panel = $PanelContainer
@onready var level_grid = $PanelContainer/ScrollContainer/LevelGrid
@onready var exit_button = $PanelContainer/ExitButton


@onready var level_selector = $VBoxContainer/LevelSelectorButton
@onready var level_editor_button = $VBoxContainer/LevelEditorButton
@onready var quit_button = $VBoxContainer/QuitButton
var LevelData = preload("res://scripts/level_data.gd").new()
var levels = LevelData.get_levels()


func _ready():
	
	
	level_selector.connect("pressed", _on_level_selected)
	settings_menu.get_popup().add_item("Volume Settings", 0)
	settings_menu.get_popup().add_item("Graphics Settings", 1)
	settings_menu.get_popup().connect("id_pressed", _on_settings_menu_selected)
	level_editor_button.connect("pressed", _on_level_editor_pressed)
	quit_button.connect("pressed", _on_quit_pressed)
	exit_button.connect("pressed", _on_exit_pressed)
	
	# Make the panel opaque / semi-transparent:
	level_selector_panel.self_modulate = Color(0, 0, 0, 0.7)  # Black with 70% opacity
	level_selector_panel.visible = false  # Hidden until "Level Selector" is pressed

func _on_volume_changed(value):
	Settings.set_volume(value)
	get_tree().change_scene_to_file("res://scenes/levelContainer.tscn")
func _on_level_selected():
	level_selector_panel.visible = not level_selector_panel.visible
	_populate_level_list()
	# Later: get_tree().change_scene_to_file(...) with actual level

func _populate_level_list():
	for child in level_grid.get_children():
		child.queue_free()

	for i in range(2):  # Adds 2 empty slots in the grid
		var spacer = Control.new()
		spacer.custom_minimum_size = Vector2(300, 100)  # Adjust height to control how much space you want
		level_grid.add_child(spacer)

	# Optional: Border style for Back Button:
	var back_style = StyleBoxFlat.new()
	back_style.border_color = Color(1, 1, 1)
	back_style.set_border_width_all(2.0)
	back_style.bg_color = Color(0.15, 0.15, 0.15)
	exit_button.add_theme_stylebox_override("normal", back_style)

	var back_hover_style = StyleBoxFlat.new()
	back_hover_style.border_color = Color(1, 1, 1)
	back_hover_style.set_border_width_all(2.0)
	back_hover_style.bg_color = Color(0.3, 0.3, 0.3)
	exit_button.add_theme_stylebox_override("hover", back_hover_style)

	
	

	# ✅ Now Add the Level Buttons:
	for level in levels:
		var button = Button.new()
		button.text = level['name']
		button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		button.custom_minimum_size = Vector2(300, 100)

		var style = StyleBoxFlat.new()
		style.border_color = Color(1, 1, 1)
		style.set_border_width_all(2.0)
		style.bg_color = Color(0.1, 0.1, 0.1)
		button.add_theme_stylebox_override("normal", style)

		var hover_style = StyleBoxFlat.new()
		hover_style.border_color = Color(1, 1, 1)
		hover_style.set_border_width_all(2.0)
		hover_style.bg_color = Color(0.2, 0.2, 0.2)
		button.add_theme_stylebox_override("hover", hover_style)

		button.connect("pressed", _on_level_button_pressed.bind(level))
		level_grid.add_child(button)

func _on_level_button_pressed(level):
	print("Selected level: ", level['name'])
	get_tree().change_scene_to_file(level['path'])


func _on_settings_menu_selected(id):
	# Just one option for now
	settings_popup.popup_centered()

func _on_level_editor_pressed():
	get_tree().change_scene_to_file("res://scenes/levelEditor.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_exit_pressed():
	# Return to your main menu scene when exit is pressed
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
