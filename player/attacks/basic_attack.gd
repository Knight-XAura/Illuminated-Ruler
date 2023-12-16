extends Area3D

const SPEED: int = 1
@export var damage = 1

func _physics_process(delta: float) -> void:
	var direction := (transform.basis * Vector3(0, 0, -1)).normalized()
	position.x += direction.x * SPEED
	position.z += direction.z * SPEED


func _on_body_entered(body: Node3D) -> void:
	hide()
	queue_free()
	if body.is_in_group("enemy"):
		body.current_health -= damage
