extends KinematicBody2D


var max_rotation_speed: float = 90.0
var rotation_speed: float = 0

var min_velocity: float = 100
var max_velocity: float = 200
var velocity: float = 0
var direction: Vector2 = Vector2.ZERO


func go_to(target: Vector2):
	direction = (target - position).normalized()


func _ready():
	rotation_speed = rand_range(-max_rotation_speed, max_rotation_speed)
	# Convert to radian
	rotation_speed = rotation_speed / 360 * 2 * PI

	velocity = rand_range(min_velocity, max_velocity)


func _physics_process(delta: float):
	rotation += rotation_speed * delta
	position += direction * velocity * delta
	
	if position.x < 0:
		queue_free()
