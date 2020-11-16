extends StaticBody2D

export var max_health: int = 100
var health = max_health

onready var health_bar = $HealthBar
onready var attack_timer = $AttackTimer
onready var attack_area = $AttackArea
onready var attack_radius = $AttackArea/AreaRadius
onready var ground = get_tree().get_root().get_node("Ground")

# The fun part
export var damage: int = 1
export var radius: int = 128
export var attack_entity = preload("res://src/scenes/Fireball.tscn")
export var attack_delay: float = 0.1

var attack_queue: Array = []

class_name TowerBase

func _ready():
	health_bar.value = health
	health_bar.max_value = max_health
	attack_timer.wait_time = attack_delay
	attack_radius.shape.radius = radius
	attack_area.connect("body_entered", self, "add_to_attack_queue")
	attack_area.connect("body_exited", self, "remove_from_attack_queue")
	attack_timer.connect("timeout", self, "attack_first_target")

func damage(amount: int):
	health -= amount
	health_bar.value = health
	if health <= 0:
		queue_free()

func _physics_process(delta):
	health_bar.visible = (health < max_health)
	if attack_queue.size() > 0:
		if attack_timer.time_left <= 0:
			attack_timer.start()

func add_to_attack_queue(body):
	attack_queue.push_back(body)
	
func remove_from_attack_queue(body):
	attack_queue.remove(attack_queue.find(body))

func attack_first_target():
	if attack_queue.size() > 0:
		var new_attack = attack_entity.instance()
		new_attack.rotation = get_angle_to(attack_queue[0].global_position) + self.get_rotation()
		new_attack.set_global_position(self.global_position)
		new_attack.direction = (attack_queue[0].global_position- self.get_position()).normalized()
		ground.add_child(new_attack)
