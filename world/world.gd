extends Node3D

@onready var roy: CharacterBody3D = $Roy
const BOX = preload("res://enemies/box/box.tscn")
const CYLINDER = preload("res://enemies/cylinder/cylinder.tscn")
const SPHERE = preload("res://enemies/sphere/sphere.tscn")
@onready var enemies_container: Node3D = $Enemies
@onready var camera: Camera3D = roy.camera
var enemies: Array[PackedScene] = [BOX, CYLINDER, SPHERE]

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#Input.mouse_mode = Input.MOUSE_MODE_CONFINED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	randomize()
	var enemy: CharacterBody3D = enemies.pick_random().instantiate()
	#while(not camera.is_position_in_frustum(enemy.position)):
	enemy.position = Vector3(randf_range(-100, 100), 1, randf_range(-100, 100)) + roy.position
	enemies_container.add_child(enemy, true)
	print("done")
