extends RigidBody2D

const SliderFactor = 12
const dragCoefficient = 0.01

var inputAllowed = true
@onready var puckHit = $"../soundFX"
var is_editor_mode := false

func _ready() -> void:
	if not is_editor_mode:
		collision_layer = 1
		collision_mask = 2 | 3 | 4  # Detect enemies, walls, and goals
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
	if event.is_action_pressed("ui_select") and (inputAllowed == true):
		puckHit.play()
		var mouse_vector = get_global_mouse_position()
		var puck_direction = mouse_vector - self.global_position
		Global.score += 1
		var impulse = puck_direction.normalized() * (PuckVelocity.puckVelocity * SliderFactor)
		apply_impulse(impulse)
		inputAllowed = false
		$"../Timer".start()

func sliderChanged(value: float) -> void:
	PuckVelocity.puckVelocity = value


func _on_timer_timeout() -> void:
	inputAllowed = true


func _on_hit_timer_timeout() -> void:
	pass # Replace with function body.
