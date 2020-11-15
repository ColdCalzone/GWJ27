extends KinematicBody2D

onready var camera = $Camera2D

const SPEED:float = 200.0

func _process(delta: float) -> void:
	var velocity:Vector2
	if Input.is_action_pressed("move_up"):
		velocity += Vector2.UP
	if Input.is_action_pressed("move_down"):
		velocity += Vector2.DOWN
	if Input.is_action_pressed("move_left"):
		velocity += Vector2.LEFT
	if Input.is_action_pressed("move_right"):
		velocity += Vector2.RIGHT
	if velocity.length() != 0:
		velocity = velocity.normalized()
	move_and_slide(velocity * SPEED)
	# Create aiming effect
	camera.position = (get_viewport().get_mouse_position() - OS.get_window_size()/2)/2

func _ready():
	pass
