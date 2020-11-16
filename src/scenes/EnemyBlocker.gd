extends StaticBody2D

export var max_health = 100
var health = max_health

onready var health_bar = $HealthBar

class_name EnemyBlocker

func _ready():
	health_bar.value = health
	health_bar.max_value = max_health

func damage(amount: int):
	health -= amount
	health_bar.value = health
	if health <= 0:
		queue_free()

func _physics_process(delta):
	health_bar.visible = (health < max_health)
