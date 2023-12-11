extends KinematicBody

var velocity = Vector3.ZERO
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
const SPEED = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var direction = Vector3.ZERO

	# Adjusted movement directions
	if Input.is_action_pressed("ui_right"):
		direction += Vector3.RIGHT
	elif Input.is_action_pressed("ui_left"):
		direction += Vector3.LEFT

	if Input.is_action_pressed("ui_up"):
		direction += Vector3.FORWARD
	elif Input.is_action_pressed("ui_down"):
		direction += Vector3.BACK

	# Normalize direction to avoid faster diagonal movement
	direction = direction.normalized()

	# Apply movement and rotation
	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED

		# Calculate target rotation
		var target_rotation = atan2(direction.x, direction.z)
		rotation.y = lerp_angle(rotation.y, target_rotation, 0.1)
	else:
		velocity.x = 0
		velocity.z = 0

	# Apply gravity
	velocity.y -= gravity * delta

	# Perform the move
	velocity = move_and_slide(velocity)
