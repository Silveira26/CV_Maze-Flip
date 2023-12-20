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
# Reference to the AnimationPlayer node.
var animation_player: AnimationPlayer

var current_animation: String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	# Capture the mouse cursor.
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Get the AnimationPlayer node.
	animation_player = get_node("AnimationPlayer")

# Override '_input' to handle mouse motion events and ESC key.
func _input(event):
	if event is InputEventMouseMotion and MultiPlayer.active_player == "Barbarian":
		# Mouse movement for camera rotation.
		var mouse_movement = event.relative * mouse_sensitivity
		rotate_y(deg2rad(-mouse_movement.x))
		var camera = get_viewport().get_camera()
		if camera  != null:
			camera.rotate_x(deg2rad(mouse_movement.y))
			camera.rotation.x = clamp(camera.rotation.x, deg2rad(-90), deg2rad(90))

	# Close the game if ESC is pressed.
	if event is InputEventKey and event.pressed and event.scancode == KEY_ESCAPE:
		get_tree().quit()

func _physics_process(delta: float):
	if MultiPlayer.active_player != "Barbarian":
		return
	on_ground = is_on_floor()
	var direction = get_input_direction()

	velocity.x = -direction.x * speed
	velocity.z = direction.z * speed

	# Apply inverted gravity.
	velocity.y -= gravity * delta  # Subtracting instead of adding

	# Inverted jump mechanic.
	if on_ground and Input.is_action_just_pressed("ui_accept"):
		velocity.y -= jump_power  # Negative jump power for inverted jump
		set_animation("Jump_Start")

	# Move the player.
	velocity = move_and_slide(velocity, Vector3.DOWN, true)  # Use Vector3.DOWN for the up direction

	# Determine the correct animation for inverted gravity.
	var animation_name = "Idle"
	if on_ground:
		if direction.length() > 0:
			animation_name = "Walking_A"
	else:
		if velocity.y > 0:
			animation_name = "Jump_Land"
		else:
			animation_name = "Jump_Idle"

	set_animation(animation_name)

# Sets the animation if it's not already playing
func set_animation(name: String):
	if current_animation != name:
		animation_player.play(name)
		current_animation = name

# This function will return the direction based on player input
func get_input_direction() -> Vector3:
	var forward = Vector3.ZERO
	var right = Vector3.ZERO
	
	# WASD movement with 180-degree rotation adjustment.
	if Input.is_key_pressed(KEY_W):  # S key moves forward
		forward -= transform.basis.z
	if Input.is_key_pressed(KEY_S):  # W key moves backward
		forward += transform.basis.z
	if Input.is_key_pressed(KEY_A):  # D key moves left
		right -= transform.basis.x
	if Input.is_key_pressed(KEY_D):  # A key moves right
		right += transform.basis.x

	return (forward + right).normalized()
