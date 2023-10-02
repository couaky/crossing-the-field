extends Node2D


export var cannon_shell: PackedScene

var min_x_cursor = 350
var number_of_cannons = 3

var turret_node: Node2D
var spawn_points: Array # Of Position2D
var spawn_cannon_index: int = 0


func _fire_cannon(shot_target: Vector2):
	print("Shoot at %s" % shot_target)
	var spawn_point = spawn_points[spawn_cannon_index]
	var created_shell = cannon_shell.instance()
	add_child(created_shell)
	created_shell.global_position = spawn_point.global_position
	created_shell.global_rotation = spawn_point.global_rotation
	created_shell.fire_at(shot_target)
	spawn_cannon_index = (spawn_cannon_index + 1) % number_of_cannons


func _ready():
	turret_node = $Cruiser/SpriteTurret
	spawn_points = [
		$Cruiser/SpriteTurret/CannonLeft,
		$Cruiser/SpriteTurret/CannonMiddle,
		$Cruiser/SpriteTurret/CannonRight
	]


func _process(delta):
	var mouse_position = get_viewport().get_mouse_position()
	mouse_position.x = max(mouse_position.x, min_x_cursor)

	turret_node.look_at(mouse_position)

	if Input.is_action_just_pressed("fire_cannons"):
		_fire_cannon(mouse_position)
