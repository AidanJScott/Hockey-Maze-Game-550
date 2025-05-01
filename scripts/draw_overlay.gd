extends Control

const GRID_SIZE := 32

@onready var drop_area := get_parent()  # DrawOverlay is child of DropArea
@onready var level_editor := get_parent().get_parent()  # DropArea's parent is LevelEditor

func _ready():
	set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

func _draw():
	if not level_editor or not level_editor.is_grid_enabled:
		return

	var drop_bounds = drop_area.get_global_rect()
	var start = drop_bounds.position
	var end = drop_bounds.end

	for x in range(int(start.x), int(end.x), GRID_SIZE):
		draw_line(Vector2(x, start.y), Vector2(x, end.y), Color(0.4, 0.4, 0.4, 0.6), 1.0)
	for y in range(int(start.y), int(end.y), GRID_SIZE):
		draw_line(Vector2(start.x, y), Vector2(end.x, y), Color(0.4, 0.4, 0.4, 0.6), 1.0)

func _process(delta):
	queue_redraw()
