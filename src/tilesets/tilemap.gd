extends TileMap

func get_current_friction(pos: Vector2):
	var map_pos = world_to_map(pos)
	var friction: float
	match get_cellv(map_pos):
		7: friction = 0.1
		_: friction = 1.0
	return friction

func get_current_accel(pos: Vector2):
	var map_pos = world_to_map(pos)
	var accel: float
	match get_cellv(map_pos):
		7: accel = 0.1
		_: accel = 1.0
	return accel

func get_current_speed(pos: Vector2):
	var map_pos = world_to_map(pos)
	var speed: float
	match get_cellv(map_pos):
		7: speed = 150.0
		_: speed = 200.0
	return speed
