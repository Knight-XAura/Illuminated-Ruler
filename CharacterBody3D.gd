extends CharacterBody3D


var mouse_pos: Vector2
#@onready var viewport: Viewport = get_viewport()
@onready var camera: Camera3D = $Camera3D
var ray_origin: Vector3
var ray_length: Vector3
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MIN_LOOK: int = -90
const MAX_LOOK: int = 90
const LOOK_SPEED: int = 10


#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseMotion or event is InputEventScreenDrag:
		#mouse_pos = viewport.get_mouse_position()


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
		#print(get_global_mouse_position())

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var space_state = get_world_3d().direct_space_state
	var mouse_pos = get_viewport().get_mouse_position()
	ray_origin = camera.project_ray_origin(mouse_pos)
	ray_length = ray_origin * camera.project_ray_normal(mouse_pos) * 2000
	var intersection = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(ray_origin, ray_length))
	if not intersection.is_empty():
		look_at(intersection["position"], Vector3(0,-1,0))
	
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
