extends Area2D


var target: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO
var speed: float = 100


func fire_at(shot_target: Vector2):
	target = shot_target
	direction = (target - position).normalized()


func _process(delta):
	position += direction * speed * delta
