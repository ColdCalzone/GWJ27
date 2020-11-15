extends KinematicBody2D

onready var camera = $Camera2D
onready var ground = get_parent()

onready var fireball = preload("res://src/scenes/Fireball.tscn")

#movement variables
var speed: float = 200.0
var friction: float = 0.1
var acceleration: float = 0.1
var velocity: Vector2

func _input(event):
	if event.is_action_pressed("attack_fireball"):
		var new_fireball = fireball.instance()
		new_fireball.rotation = get_angle_to(get_global_mouse_position()) + self.get_rotation()
		new_fireball.set_global_position(self.global_position)
		new_fireball.direction = (get_global_mouse_position()- self.get_position()).normalized()
		ground.add_child(new_fireball)

func _process(delta: float) -> void:
	var dir: Vector2 = Vector2(0, 0)
	# Sets the friction, accel, and speed based on the current tile.
	# Pretty dynamic, so if I ever decide I need something new
	# the option is there
	friction = ground.get_current_friction(position)
	acceleration = ground.get_current_accel(position)
	#speed = ground.get_current_speed(position)
	
	if Input.is_action_pressed("move_up"):
		dir += Vector2.UP
	if Input.is_action_pressed("move_down"):
		dir += Vector2.DOWN
	if Input.is_action_pressed("move_left"):
		dir += Vector2.LEFT
	if Input.is_action_pressed("move_right"):
		dir += Vector2.RIGHT
	if dir.length() != 0:
		# Used for ice physics, decreasing acceleration when on an ice tile
		# (see tilemap.gd)
		velocity.x = lerp(velocity.x, dir.x * speed, acceleration)
		velocity.y = lerp(velocity.y, dir.y * speed, acceleration)
		velocity = velocity.normalized()
	else:
		# Used for ice physics, decreasing friction when on an ice tile
		# (see tilemap.gd)
		velocity.x = lerp(velocity.x, 0, friction)
		velocity.y = lerp(velocity.y, 0, friction)
	move_and_slide(velocity * speed)

	# Create aiming effect
	camera.position = (get_viewport().get_mouse_position() - OS.get_window_size()/2)/2

func _ready():
	pass
