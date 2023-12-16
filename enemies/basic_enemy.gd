extends CharacterBody3D
class_name BasicEnemy

@export var max_health: int = 3
@export var current_health: int = 3:
	set(value):
		current_health = value
		if current_health <= 0:
			hide()
			queue_free()
@export var damage: int = 1
@export var experience: int = 1
var sucked_blood: bool
var roy: CharacterBody3D
@export var speed: int = 3
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent
@onready var area_3d: Area3D = $Area3D
@onready var attack_timer: Timer = $AttackTimer


func _physics_process(delta: float) -> void:
	set_movement_target(roy.global_position)
	if navigation_agent.is_navigation_finished():
		return

	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * speed
	move_and_slide()

func _ready():
	roy = get_node("/root/World/Roy")

	# Make sure to not await during _ready.
	call_deferred("actor_setup")

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(roy.global_position)

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if not sucked_blood:
		print("BLOOD SUCKED")
		sucked_blood = true
		mesh_instance.mesh.material.albedo_color = Color.RED
		navigation_agent.target_desired_distance = 5
		navigation_agent.path_desired_distance = 5
		attack_timer.start()
		


func _on_area_3d_body_exited(body: Node3D) -> void:
	attack_timer.stop()


func _on_timer_timeout() -> void:
	roy.current_health -= damage
