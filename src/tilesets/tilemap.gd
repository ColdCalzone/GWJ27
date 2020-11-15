extends TileMap

# yoink! F&F2 source code: https://bitbucket.org/JohnGabrielUK/fire-and-fondness-2/src/master
func _ready():
	var map_size : Vector2 = get_map_size()
	var data : Array = []
	for y in map_size.y:
		var row : Array = []
		for x in map_size.x:
			row.append(get_cell(x, y))
		data.append(row)
	print(data)
	OS.clipboard = String(data)
	
func get_map_size() -> Vector2: 
	var result : Vector2 = Vector2.ZERO
	# 0 = Grass
	# 1 = Dirt
	# 2 = Dirt w/ pebbles
	# 3 = Gravel
	# 4 = Stone
	# 5 = Dark Stone
	# 6 = Water
	# 7 = Ice
	for tile in get_used_cells():
		if get_cellv(tile) == 6:
			continue
		result.x = max(result.x, tile.x+1)
		result.y = max(result.y, tile.y+1)
	print(result)
	return result

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
