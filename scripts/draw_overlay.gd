extends Control

const GRID_SIZE := 32

@onready var drop_area := get_parent()  # DrawOverlay is child of DropArea
@onready var level_editor := get_parent().get_parent()  # DropArea's parent is LevelEditor

func _ready():
	set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

func _draw():
	# Always draw the yellow border around the full DrawOverlay rect
	draw_rect(Rect2(Vector2.ZERO, size), Color.YELLOW, false, 2.0)

	if not level_editor or not level_editor.is_grid_enabled:
		return

	for x in range(0, int(size.x), GRID_SIZE):
		draw_line(Vector2(x, 0), Vector2(x, size.y), Color(0.4, 0.4, 0.4, 0.6), 1.0)
	for y in range(0, int(size.y), GRID_SIZE):
		draw_line(Vector2(0, y), Vector2(size.x, y), Color(0.4, 0.4, 0.4, 0.6), 1.0)

func _process(delta):
	queue_redraw()
