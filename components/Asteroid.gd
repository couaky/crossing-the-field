class_name Asteroid
extends Area2D


export var explosion_scene: PackedScene

var max_rotation_speed: float = 90.0
var rotation_speed: float = 0

var velocity: float = 0
var direction: Vector2 = Vector2.ZERO


func go_to(target: Vector2):
	direction = (target - position).normalized()


func _explode():
	var new_explosion = explosion_scene.instance() as Explosion
	get_node("/root").add_child(new_explosion)
	new_explosion.position = global_position
	new_explosion.asteroid_explosion()
	queue_free()


func _ready():
	rotation_speed = rand_range(-max_rotation_speed, max_rotation_speed)
	# Convert to radian
	rotation_speed = rotation_speed / 360 * 2 * PI


func _process(delta: float):
	rotation += rotation_speed * delta
	position += direction * velocity * delta
	
	if position.x < 0:
		queue_free()


func _on_Asteroid_area_shape_entered(_area_rid, _area, _area_shape_index, _local_shape_index):
	call_deferred("_explode")
