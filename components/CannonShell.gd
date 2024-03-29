class_name CannonShell
extends Area2D


export var shockwave_scene: PackedScene
export var explosion_scene: PackedScene

var epsilon = 0.1
var target: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO
var speed: float = 300


func fire_at(shot_target: Vector2):
	target = shot_target
	direction = (target - position).normalized()


func _detonate():
	var root_node = get_node('/root')

	var shockwave = shockwave_scene.instance() as ShockWave
	root_node.add_child(shockwave)
	shockwave.position = global_position
	shockwave.play("Shell")

	var explosion = explosion_scene.instance() as Explosion
	root_node.add_child(explosion)
	explosion.position = global_position
	explosion.shell_explosion()

	queue_free()


func _process(delta):
	var distance_to_target = position.distance_to(target)
	if distance_to_target < epsilon:
		return _detonate()

	position += direction * min(speed * delta, distance_to_target)


func _on_CannonShell_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	call_deferred("_detonate")
