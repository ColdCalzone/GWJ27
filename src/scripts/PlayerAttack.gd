extends KinematicBody2D

export var direction: Vector2 = Vector2.UP
export var damage: int = 1
var speed = 100
#onready var collision = $Collision
class_name PlayerAttack

func _ready():
	self.set_z_index(100)
