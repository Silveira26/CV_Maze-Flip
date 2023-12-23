extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 5.0
var mouse_sensitivity: float = 0.05

var animation_player: AnimationPlayer
var current_animation: String = ""

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = -ProjectSettings.get_setting("physics/3d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	animation_player = get_node("AnimationPlayer")

func _input(event):
	# Camera control
	if event is InputEventMouseMotion:
		var mouse_movement = event.relative * mouse_sensitivity
		rotate_y(deg_to_rad(-mouse_movement.x))
		var camera = get_viewport().get_camera_3d()
		if camera != null:
			camera.rotate_x(deg_to_rad(mouse_movement.y))
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

	# Exit game
	if event is InputEventKey and event.pressed and event.as_text() == "Escape":
		get_tree().quit()

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = get_input_direction()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(-velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
				
	# Apply inverted gravity.
	velocity.y += gravity * delta  # Subtracting instead of adding

	# Inverted jump mechanic.
	if is_on_floor() and Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY  # Negative jump power for inverted jump
		set_animation("Jump_Start")

	move_and_slide()
	# Determine the correct animation for inverted gravity.
	var animation_name = "Idle"
	if is_on_floor():
		if direction.length() > 0:
			animation_name = "Walking_A"
	else:
		if velocity.y < 0:
			animation_name = "Jump_Land"
		else:
			animation_name = "Jump_Idle"

	set_animation(animation_name)
	
func set_animation(name: String):
	if current_animation != name:
		animation_player.play(name)
		current_animation = name
		
func get_input_direction() -> Vector3:
	var forward = Vector3.ZERO
	var right = Vector3.ZERO
	
	# WASD movement with 180-degree rotation adjustment.
	if Input.is_key_pressed(KEY_W):  # S key moves forward
		forward += transform.basis.z
	if Input.is_key_pressed(KEY_S):  # W key moves backward
		forward -= transform.basis.z
	if Input.is_key_pressed(KEY_A):  # D key moves left
		right += transform.basis.x
	if Input.is_key_pressed(KEY_D):  # A key moves right
		right -= transform.basis.x

	return (forward + right).normalized()
