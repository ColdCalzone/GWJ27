extends KinematicBody2D

onready var ray = $BlockerCheck
onready var collision = $Collision
onready var attack_delay = $AttackTimer
onready var attack_reciever = $AttackReciever
onready var tween = $Tween
onready var sprite = $Sprite
onready var spawner = get_parent()
onready var health_bar = $HealthBar
onready var path = get_tree().get_root().get_node("Ground/EnemyPath")

export var ray_position: int = -50
export var damage: int = 1
var points
var index = 0

# movement stuff
# ok so like I tried to set this to 200 and it didn't work so I think this one's cursed folks
# @ 135 it moves forward about a tile and just spazs out again
# @ 134 it moves forward about 12 tiles and just spazs out again again
# @ 133 it works
# ????????????????????????????????????????????????????????????????????
export var speed: float = 100.0
#this stuff just doesn't??? work??? idk just don't touchy
export var friction: float = 0.1
export var acceleration: float = 1.0
var velocity: Vector2

export var max_health: int = 5
var health: int = max_health

class_name Enemy

func _ready():
	health = max_health
	ray.cast_to.x = ray_position
	attack_delay.connect("timeout", self, "start_attack")
	health_bar.value = health
	health_bar.max_value = max_health
	attack_reciever.connect("body_entered", self, "damage")

func _physics_process(delta: float):
	health_bar.visible = (health < max_health)
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
		if (target - position).length() != 0:
			move_and_slide(velocity*speed)
	else:
		if attack_delay.time_left <= 0:
			attack_delay.start()

func start_attack():
	attack_blocker(ray.get_collider())

func attack_blocker(blocker):
	if blocker is EnemyBlocker:
		tween.interpolate_property(sprite, "offset", Vector2(0,0), ray.cast_to, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.interpolate_property(sprite, "offset", ray.cast_to, Vector2(0,0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.25)
		tween.start()
		blocker.damage(damage)

func damage(body):
	if body is PlayerAttack:
		health -= body.damage
		health_bar.value = health
		if health <= 0:
			queue_free()
		body.queue_free()
