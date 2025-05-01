extends RigidBody2D

const SliderFactor = 7
const dragCoefficient = 0.01

var is_editor_mode := false

func _ready() -> void:
	# Only applies if not in editor mode
	if not is_editor_mode:
		collision_layer = 1
		collision_mask = 2
		add_to_group("puck")
  # "I want to detect Layer 2 (enemies)"

func _process(delta: float) -> void:
	if is_editor_mode:
		return
	var drag_force = -self.linear_velocity * dragCoefficient
	apply_central_impulse(drag_force)

func _input(event: InputEvent) -> void:
	if is_editor_mode:
		return
	if event.is_action_pressed("ui_select"):
		var mouse_vector = get_global_mouse_position()
		var puck_direction = mouse_vector - self.global_position
		var impulse = puck_direction.normalized() * (PuckVelocity.puckVelocity * SliderFactor)
		apply_impulse(impulse)

func sliderChanged(value: float) -> void:
	PuckVelocity.puckVelocity = value
