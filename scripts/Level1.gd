extends Node3D

# Camera references
@onready var cameras_top = [$MazeTop/Player/FirstPersonCam, $MazeTop/Player/ThirdPersonCam, $MazeTop/Player/TopViewCam]
@onready var cameras_bottom = [$MazeBottom/Player/FirstPersonCam, $MazeBottom/Player/ThirdPersonCam, $MazeBottom/Player/TopViewCam]

# Sensitivity of the mouse movement.
var mouse_sensitivity: float = 0.05

var current_maze = "top"
var current_camera_index = 0

func _ready() -> void:
	# Initialize by making the first camera in MazeTop active
	cameras_top[current_camera_index].make_current()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("swap_camera"):
		swap_cameras()
	elif Input.is_action_just_pressed("swap_maze"):
		swap_maze()
	elif Input.is_action_just_pressed("toggle_projection"):
		toggle_camera_projection()

func swap_cameras() -> void:
	# Determine the next camera index
	var next_camera_index = (current_camera_index + 1) % get_current_camera_array().size()

	# Get the current and next cameras
	var current_camera = get_current_camera_array()[current_camera_index]
	var next_camera = get_current_camera_array()[next_camera_index]

	# Use CameraTransition for a smooth transition
	CameraTransition.transition_camera3D(current_camera, next_camera, 1.5)

	# Update the current camera index
	current_camera_index = next_camera_index

func swap_maze() -> void:
	# Toggle between top and bottom mazes
	var next_maze = "bottom" if current_maze == "top" else "top"
	var next_camera = cameras_top[0] if next_maze == "top" else cameras_bottom[0]

	# Use CameraTransition for a smooth transition
	CameraTransition.transition_camera3D(get_current_camera_array()[current_camera_index], next_camera, 1.5)
	
	MultiPlayer.switch_player()

	# Update the maze and reset the camera index
	current_maze = next_maze
	current_camera_index = 0

func get_current_camera_array() -> Array:
	return cameras_top if current_maze == "top" else cameras_bottom
	
func toggle_camera_projection() -> void:
	var current_camera = get_current_camera()
	if current_camera != null:
		if current_camera.projection == Camera3D.PROJECTION_PERSPECTIVE:
			current_camera.projection = Camera3D.PROJECTION_ORTHOGONAL
		else:
			current_camera.projection = Camera3D.PROJECTION_PERSPECTIVE
func get_current_camera() -> Camera3D:
	return get_current_camera_array()[current_camera_index]
