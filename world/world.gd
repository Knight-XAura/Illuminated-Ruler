extends Node3D

@onready var roy: CharacterBody3D = $Roy
const BOX = preload("res://enemies/box/box.tscn")
const CYLINDER = preload("res://enemies/cylinder/cylinder.tscn")
const SPHERE = preload("res://enemies/sphere/sphere.tscn")
@onready var enemies_container: Node3D = $Enemies
@onready var camera: Camera3D = roy.camera
var enemies: Array[PackedScene] = [BOX, CYLINDER, SPHERE]
@onready var spawn_timer: Timer = $SpawnTimer


func _on_timer_timeout() -> void:
	spawn_timer.wait_time -= .005
	randomize()
	var enemy: CharacterBody3D = enemies.pick_random().instantiate()
	enemy.position = Vector3(randf_range(-100, 100), 1, randf_range(-100, 100)) + roy.global_transform.origin
	while(camera.is_position_in_frustum(enemy.position)):
		enemy.position = Vector3(randf_range(-100, 100), 1, randf_range(-100, 100)) + roy.global_transform.origin
	enemies_container.add_child(enemy, true)
