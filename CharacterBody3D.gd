extends CharacterBody3D

@onready var camera: Camera3D = $Camera3D
var ray_length: int = 2000
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MIN_LOOK: int = -90
const MAX_LOOK: int = 90
const LOOK_SPEED: int = 10


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		var mouse_pos = get_viewport().get_mouse_position()
		var space = get_world_3d().direct_space_state
		var ray_query = PhysicsRayQueryParameters3D.new()
		ray_query.from = camera.project_ray_origin(mouse_pos)
		ray_query.to = ray_query.from + camera.project_ray_normal(mouse_pos) * ray_length
		var raycast_result = space.intersect_ray(ray_query)
		look_at(raycast_result["position"])


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
