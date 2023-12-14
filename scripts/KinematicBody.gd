extends KinematicBody

# Speed of the player movement.
var speed: float = 10.0
# Jump power.
var jump_power: float = 5.0
# Sensitivity of the mouse movement.
var mouse_sensitivity: float = 0.05
# Gravity value.
var gravity: float = -9.8
# Velocity of the player.
var velocity: Vector3 = Vector3.ZERO
# To keep track of whether the player is on the ground.
var on_ground: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	# Capture the mouse cursor.
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Override '_input' to handle mouse motion events and ESC key.
func _input(event):
	if event is InputEventMouseMotion:
		# Mouse movement for camera rotation.
		var mouse_movement = event.relative * mouse_sensitivity
		rotate_y(deg2rad(-mouse_movement.x))
		$Camera.rotate_x(deg2rad(-mouse_movement.y))
		$Camera.rotation.x = clamp($Camera.rotation.x, deg2rad(-90), deg2rad(90))

	# Close the game if ESC is pressed.
	if event is InputEventKey and event.pressed and event.scancode == KEY_ESCAPE:
		get_tree().quit()

# Called every physics frame (fixed frame rate).
func _physics_process(delta: float):
	on_ground = is_on_floor()

	var forward = Vector3.ZERO
	var right = Vector3.ZERO

	# WASD movement.
	if Input.is_key_pressed(KEY_W): #UP
		forward -= transform.basis.z
	if Input.is_key_pressed(KEY_S): #DOWN
		forward += transform.basis.z
	if Input.is_key_pressed(KEY_A): #LEFT
		right -= transform.basis.x
	if Input.is_key_pressed(KEY_D): #Right
		right += transform.basis.x

	var direction = (forward + right).normalized()
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	# Apply gravity.
	velocity.y += gravity * delta

	# Jump mechanic.
	if on_ground and Input.is_action_just_pressed("ui_accept"): # assuming ui_accept is the space bar
		velocity.y = jump_power

	# Move the player.
	velocity = move_and_slide(velocity, Vector3.UP)
