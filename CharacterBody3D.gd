extends CharacterBody3D

@onready var camera_3d: Camera3D = $Camera3D


var mouse_delta: Vector2
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MIN_LOOK: int = -90
const MAX_LOOK: int = 90
const LOOK_SPEED: int = 10


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		mouse_delta = event.relative


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	mouse_delta *= LOOK_SPEED * delta
	camera_3d.rotation_degrees.x = clamp(camera_3d.rotation_degrees.x - mouse_delta.y, MIN_LOOK, MAX_LOOK)
	rotation_degrees.y -= mouse_delta.x
	
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
