extends Node2D

onready var board = get_tree().get_root().get_node("Ground")
onready var path_container = get_parent().get_node("EnemyPath")
export var path: Array = [Vector2(672, -416), Vector2(352, -416), Vector2(352, -352), Vector2(160, -352), Vector2(160, -32), Vector2(352, -32), Vector2(352, 416), Vector2(-96, 416), Vector2(-96, 96), Vector2(160, 96), Vector2(160, 224), Vector2(96, 224)]

func _ready():
	for i in path:
		path_container.curve.add_point(i)
	for i in get_children():
		i.points = path_container.curve.get_baked_points()

func get_current_friction(pos: Vector2):
	var map_pos = board.world_to_map(pos)
	var friction: float
	match board.get_cellv(map_pos):
		7: friction = 0.7
		_: friction = 0.1
	return friction

func get_current_accel(pos: Vector2):
	var map_pos = board.world_to_map(pos)
	var accel: float
	match board.get_cellv(map_pos):
		7: accel = 0.5
		_: accel = 1.0
	return accel
