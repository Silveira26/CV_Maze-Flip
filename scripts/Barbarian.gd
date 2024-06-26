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
	if event is InputEventKey and event.pressed and event.scancode == KEY_Q:
		Global.switch_player()

	if event is InputEventMouseMotion and Global.active_player == "Barbarian":
		# Mouse movement for camera rotation.
		var mouse_movement = event.relative * mouse_sensitivity
		rotate_y(deg2rad(-mouse_movement.x))
		if $Camera  != null:
			$Camera.rotate_x(deg2rad(mouse_movement.y))
			$Camera.rotation.x = clamp($Camera.rotation.x, deg2rad(-90), deg2rad(90))

	# Close the game if ESC is pressed.
	if event is InputEventKey and event.pressed and event.scancode == KEY_ESCAPE:
		get_tree().quit()

func _physics_process(delta: float):
	if Global.active_player != "Barbarian":
		return
	on_ground = is_on_floor()
	var direction = get_input_direction()

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	# Apply gravity.
	velocity.y += gravity * delta

	# Jump mechanic.
	if on_ground and Input.is_action_just_pressed("ui_accept"):
		velocity.y = jump_power
		set_animation("Jump_Start")

	# Move the player.
	velocity = move_and_slide(velocity, Vector3.UP, true)

	# Determine the correct animation.
	var animation_name = "Idle"
	if on_ground:
		if direction.length() > 0:
			animation_name = "Walking_A"
	else:
		if velocity.y < 0:
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
	
	# WASD movement.
	if Input.is_key_pressed(KEY_W):
		forward += transform.basis.z
	if Input.is_key_pressed(KEY_S):
		forward -= transform.basis.z
	if Input.is_key_pressed(KEY_A):
		right += transform.basis.x
	if Input.is_key_pressed(KEY_D):
		right -= transform.basis.x

	return (forward + right).normalized()
