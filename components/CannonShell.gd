extends Area2D


var epsilon = 0.1
var target: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO
var speed: float = 100


func fire_at(shot_target: Vector2):
	target = shot_target
	direction = (target - position).normalized()


func _detonate():
	queue_free()


func _process(delta):
	var distance_to_target = position.distance_to(target)
	if distance_to_target < epsilon:
		return _detonate()

	position += direction * min(speed * delta, distance_to_target)


func _on_CannonShell_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	_detonate()
