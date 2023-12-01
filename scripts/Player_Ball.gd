extends KinematicBody


var velocity = Vector3.ZERO
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
const SPEED = 5
const ROTSPEED = 7


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_left"):
		velocity.x = 0
	elif Input.is_action_pressed("ui_right"):
		velocity.x = -SPEED
		$MeshInstance.rotate_z(deg2rad(ROTSPEED))
	elif Input.is_action_pressed("ui_left"):
		velocity.x = SPEED
		$MeshInstance.rotate_z(deg2rad(-ROTSPEED))
	else:
		velocity.x = lerp(velocity.x,0,0.1)
	
	if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_down"):
		velocity.z = 0
	elif Input.is_action_pressed("ui_down"):
		velocity.z = -SPEED
		$MeshInstance.rotate_x(deg2rad(-ROTSPEED))
	elif Input.is_action_pressed("ui_up"):
		velocity.z = SPEED
		$MeshInstance.rotate_x(deg2rad(ROTSPEED))
	else:
		velocity.z = lerp(velocity.z,0,0.1)
		
	velocity.y -= gravity * delta
	
	move_and_slide(velocity)
