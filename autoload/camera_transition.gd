extends Node

@onready var camera2D: Camera2D = $Camera2D
@onready var camera3D: Camera3D = $Camera3D
var tween

var transitioning: bool = false

func _ready() -> void:
	tween = get_tree().create_tween()
	camera2D.enabled = false
	camera3D.clear_current()


func switch_camera(from, to) -> void:
	from.current = false
	to.current = true

func transition_camera2D(from: Camera2D, to: Camera2D, duration: float = 1.0) -> void:
	if transitioning: return
	# Copy the parameters of the first camera
	camera2D.zoom = from.zoom
	camera2D.offset = from.offset
	camera2D.light_mask = from.light_mask
	
	# Move our transition camera to the first camera position
	camera2D.global_transform = from.global_transform
	
	# Make our transition camera current
	camera2D.enabled = true
	
	transitioning = true
	
	# Move to the second camera, while also adjusting the parameters to
	# match the second camera
	tween.stop()
	tween.tween_property(camera2D, "global_transform", to.global_transform, duration)
	tween.tween_property(camera2D, "zoom", to.zoom, duration)
	tween.tween_property(camera2D, "offset", to.offset, duration)
	tween.play()
	
	# Wait for the tween to complete
	await tween.finished
	
	# Make the second camera current
	to.enabled = true
	transitioning = false

func transition_camera3D(from: Camera3D, to: Camera3D, duration: float = 1.0) -> void:
	if transitioning: return
	# Copy the parameters of the first camera
	camera3D.fov = from.fov
	camera3D.cull_mask = from.cull_mask
	
	# Move our transition camera to the first camera position
	camera3D.global_transform = from.global_transform
	
	# Make our transition camera current
	camera3D.make_current()
	
	transitioning = true
		
	# Move to the second camera, while also adjusting the parameters to
	# match the second camera
	tween.stop()
	tween.tween_property(camera3D, "global_transform", to.global_transform, duration)
	tween.tween_property(camera3D, "fov", to.fov, duration)
	tween.play()
	
	# Wait for the tween to complete
	await tween.finished
	
	# Make the second camera current
	to.make_current()
	transitioning = false
