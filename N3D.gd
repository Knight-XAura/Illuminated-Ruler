extends Node3D


@onready var node_placement: Marker3D = $Cave/NodePlacement as Marker3D
@onready var cave: Node3D = $Cave
var wall: PackedScene = preload("res://wall.tscn")
var map: Image = preload("res://map.jpg")


func _ready() -> void:
	for x_coord in map.get_width():
		node_placement.position.x = x_coord
		for y_coord in map.get_height():
			node_placement.position.z = y_coord
			if map.get_pixel(x_coord, y_coord).g8 <= 127:
				var wall_node: CSGBox3D = wall.instantiate()
				wall_node.position = node_placement.position
				cave.add_child(wall_node, true)
		print("Row %s Complete" % [x_coord])
		await get_tree().create_timer(.05).timeout
	cave.position -= Vector3(203, 0, 189)
	node_placement.queue_free()
			
