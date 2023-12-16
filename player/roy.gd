extends CharacterBody3D

signal leveled_up(new_level: int)
signal health_changed(current: int, max: int)
signal died
signal gained_experience(gained_exp: int)


@onready var camera: Camera3D = $Camera3D
var ray_length: int = 100
var ray_query = PhysicsRayQueryParameters3D.new()
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var attack_scene = preload("res://player/attacks/basic_attack.tscn")

var level: int = 1
var experience: int = 0
var next_level_experience: int = 10
var max_health: int = 100
var current_health: int = 100:
	set(value):
		current_health = value
		health_changed.emit(current_health, max_health)
		if current_health <= 0:
			died.emit()

const SPEED = 5.0


func _ready() -> void:
	ray_query.set_collision_mask(1)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_pos = get_viewport().get_mouse_position()
		var space = get_world_3d().direct_space_state
		ray_query.from = camera.project_ray_origin(mouse_pos + Vector2(16, 16))
		ray_query.to = ray_query.from + camera.project_ray_normal(mouse_pos) * ray_length
		var raycast_result = space.intersect_ray(ray_query)
		if raycast_result.is_empty():
			return
		look_at(raycast_result["position"])


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	camera.global_position.x = position.x
	camera.global_position.z = position.z


func _on_area_3d_body_entered(body: Node3D) -> void:
	current_health -= body.damage


func _on_attack_timer_timeout() -> void:
	var attack = attack_scene.instantiate()
	var attacks: Node3D = $Attacks
	attacks.add_child(attack, true)

	
