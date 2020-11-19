extends Node2D

onready var board = get_tree().get_root().get_node("Ground")
onready var path_container = get_parent().get_node("EnemyPath")
export var path: Array #= [Vector2(672, -416), Vector2(352, -416), Vector2(352, -352), Vector2(160, -352), Vector2(160, -32), Vector2(352, -32), Vector2(352, 416), Vector2(-96, 416), Vector2(-96, 96), Vector2(160, 96), Vector2(160, 224), Vector2(96, 224)]

var enemy = preload("res://src/scenes/Enemy.tscn")

func _ready():
	for j in path_container.get_children():
		path.append(board.map_to_world(board.world_to_map(j.position)) + Vector2(32, 32))
	print(path)
	for i in path:
		path_container.curve.add_point(i)
	var enemy_inst = enemy.instance()
	enemy_inst.position = path[0]
	enemy_inst.max_health = 7_500_000
	enemy_inst.damage = 100
	add_child(enemy_inst)
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
