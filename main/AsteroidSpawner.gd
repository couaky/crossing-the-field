extends Node


export var asteroid_scene: PackedScene

var chance_to_spawn = 0.2

var asteroid_mean_speed: float = 100
var asteroid_deviation: float = 25
var asteroid_min_speed: float = 50

var rng = RandomNumberGenerator.new()


func _spawn_asteroid():
	var viewport_size = get_viewport().size
	var spawn_position = Vector2(
		viewport_size.x - 10,
		rand_range(10, viewport_size.y - 10))
	var target_position = Vector2(
		10,
		rand_range(10, viewport_size.y - 10))

	var new_asteroid = asteroid_scene.instance() as Asteroid
	add_child(new_asteroid)
	new_asteroid.position = spawn_position
	new_asteroid.go_to(target_position)
	new_asteroid.velocity = max(rng.randfn(asteroid_mean_speed, asteroid_deviation), asteroid_min_speed)


func _on_SpawnTimer_timeout():
	var spawn_odd = randf()
	if spawn_odd < chance_to_spawn:
		_spawn_asteroid()
