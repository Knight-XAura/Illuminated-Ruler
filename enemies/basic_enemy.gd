extends CharacterBody3D
class_name BasicEnemy

@export var max_health: int = 10
@export var current_health: int = 10
@export var damage: int = 1
@export var experience: int = 1
var sucked_blood: bool
var roy: CharacterBody3D
@export var speed: int = 3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	roy = get_node("/root/World/Roy")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity = global_position.direction_to(roy.global_position)
	velocity = velocity * speed
	move_and_slide()
