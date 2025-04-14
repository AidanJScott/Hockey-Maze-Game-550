extends RigidBody2D
const SliderFactor = 7
const dragCoefficient = 0.01


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sliderValue = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Assuming 'velocity' is a Vector2 representing the object's velocity
	var dragForce = -self.get_linear_velocity() * dragCoefficient # drag_coefficient is a value between 0 and 1
	# Apply the drag force
	apply_central_impulse(dragForce)

func _input(event: InputEvent) -> void:
	# On spacebar clicked
	if event.is_action_pressed("ui_select"):
		# get the position of the mouse and the position of the puck, 
		# find the difference to get a vector relative to the puck
		var mouseVector = get_global_mouse_position()
		var puckDirection = mouseVector - self.global_position
		
		# normalize the vector to make mouse distance from the puck have no effect
		var unitPuckDirection = puckDirection.normalized()
		
		# multiply the normalized vector by the value on the slider 
		# and apply the force to the puck
		unitPuckDirection *= Vector2(PuckVelocity.puckVelocity * SliderFactor, PuckVelocity.puckVelocity * SliderFactor)
		apply_impulse(unitPuckDirection)


func sliderChanged(value: float) -> void:
	PuckVelocity.puckVelocity = value
