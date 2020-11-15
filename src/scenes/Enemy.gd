extends KinematicBody2D

onready var ray = $BlockerCheck
onready var collision = $Collision
onready var attack_delay = $AttackTimer
onready var spawner = get_parent()
export var ray_position: int = -50
export var damage: int = 2
onready var path = get_tree().get_root().get_node("Ground/EnemyPath")
var points
var index = 0

# movement stuff
var speed: float = 100.0
#this stuff just doesn't??? work???
var friction: float = 0.1
var acceleration: float = 0.1
var velocity: Vector2

# pathing stuff

class_name Enemy

func _ready():
	ray.cast_to.x = ray_position
	attack_delay.connect("timeout", self, "start_attack")

func _physics_process(delta: float):
	var target = points[index]
	if position.distance_to(target) < 1:
		index = wrapi(index + 1, 0, points.size())
		target = points[index]
	if round(target.x - position.x) > 1:
		ray.cast_to.x = -ray_position
	elif round(target.x - position.x) < -1:
		ray.cast_to.x = ray_position
	else:
		ray.cast_to.x = 0
	if round(target.y - position.y) > 1:
		ray.cast_to.y = -ray_position
	elif round(target.y - position.y) < -1:
		ray.cast_to.y = ray_position
	else:
		ray.cast_to.y = 0
	# Used for ice physics, decreasing acceleration when on an ice tile
	# (see EnemySpawner.gd)
	
	#friction = spawner.get_current_friction(position)
	#acceleration = spawner.get_current_accel(position)
	
	velocity.x = lerp(velocity.x, (target - position).normalized().x * speed, acceleration)
	velocity.y = lerp(velocity.y, (target - position).normalized().y * speed, acceleration)
	velocity = velocity.normalized()
	# Used for ice physics, decreasing friction when on an ice tile
	# (see EnemySpawner.gd)
	velocity.x = lerp(velocity.x, 0, friction)
	velocity.y = lerp(velocity.y, 0, friction)
	
	if !is_instance_valid(ray.get_collider()):
		move_and_slide(velocity * speed)
	else:
		if attack_delay.time_left <= 0:
			attack_delay.start()

func start_attack():
	attack_blocker(ray.get_collider())

func attack_blocker(blocker):
	if blocker is EnemyBlocker:
		blocker.damage(damage)
		
