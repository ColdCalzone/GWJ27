extends PlayerAttack

class_name Fireball

func _ready():
	$AnimatedSprite.play("default")
	speed = 300

func _physics_process(delta):
	move_and_slide(direction * speed)
