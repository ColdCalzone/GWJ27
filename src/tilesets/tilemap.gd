extends TileMap

onready var garbage_area = $ItsGarbageDay
onready var garbage_area_shape = $ItsGarbageDay/Shape

# yoink! F&F2 source code: https://bitbucket.org/JohnGabrielUK/fire-and-fondness-2/src/master
func _ready():
	var map_size : Vector2 = get_map_size()
	var data : Array = []
	for y in map_size.y:
		var row : Array = []
		for x in map_size.x:
			row.append(get_cell(x, y))
		data.append(row)
	#print(data)
	OS.clipboard = String(data)
	garbage_area.connect("body_exited", self, "take_out_the_trash")
	garbage_area.position = map_to_world(get_map_size()/2)
	garbage_area_shape.shape.extents = (get_map_size()/2)*64
	
func get_map_size() -> Vector2: 
	var result : Vector2 = Vector2.ZERO
	
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
		21: friction = 0.1
		_: friction = 1.0
	return friction

func get_current_accel(pos: Vector2):
	var map_pos = world_to_map(pos)
	var accel: float
	match get_cellv(map_pos):
		21: accel = 0.1
		_: accel = 1.0
	return accel

func get_current_speed(pos: Vector2):
	var map_pos = world_to_map(pos)
	var speed: float
	match get_cellv(map_pos):
		7: speed = 150.0
		_: speed = 200.0
	return speed

func take_out_the_trash(body):
	body.queue_free()
