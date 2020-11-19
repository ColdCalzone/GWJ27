extends StaticBody2D

export var max_health: int = 100
var health: int = max_health

onready var health_bar = $HealthBar

class_name EnemyBlocker

func _ready():
	health = max_health
	health_bar.value = health
	health_bar.max_value = max_health

func damage(amount: int):
	#print("owie ", amount)
	#print(health)
	health -= amount
	#print(health)
	health_bar.value = health
	if health <= 0:
		queue_free()

func _physics_process(delta):
	health_bar.visible = (health < max_health)
