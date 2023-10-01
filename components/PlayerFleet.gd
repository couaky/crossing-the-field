extends Node2D


export var cannon_shell: PackedScene

var min_x_cursor = 350

var turret_node: Node2D


func _fire_cannon(shot_target: Vector2):
	print("Shoot at %s" % shot_target)
	var created_shell = cannon_shell.instance()
	add_child(created_shell)
	created_shell.global_position = turret_node.global_position
	created_shell.global_rotation = turret_node.global_rotation
	created_shell.fire_at(shot_target)


func _ready():
	turret_node = $Cruiser/SpriteTurret


func _process(delta):
	var mouse_position = get_viewport().get_mouse_position()
	mouse_position.x = max(mouse_position.x, min_x_cursor)

	turret_node.look_at(mouse_position)

	if Input.is_action_just_pressed("fire_cannons"):
		_fire_cannon(mouse_position)
