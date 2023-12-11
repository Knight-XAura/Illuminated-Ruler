extends Node3D


@onready var cave: StaticBody3D = $Cave
var wall: PackedScene = preload("res://wall.tscn")
var map: Image = preload("res://map.jpg")


func _ready() -> void:
	for x_coord in map.get_width():
		for y_coord in map.get_height():
			if map.get_pixel(x_coord, y_coord).g8 <= 127:
				var wall_node: CSGBox3D = wall.instantiate()
				wall_node.position = Vector3(x_coord, 0, y_coord)
				cave.add_child(wall_node, true)
	cave.position -= Vector3(405, 0, 378)
			
