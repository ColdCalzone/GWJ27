extends StaticBody2D

export var health = 100

onready var health_bar = $HealthBar

class_name EnemyBlocker

func _ready():
	health_bar.value = health

func damage(amount: int):
	health -= amount
	health_bar.value = health
	if health <= 0:
		queue_free()
