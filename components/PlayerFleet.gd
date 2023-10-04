extends Node2D


export var cannon_shell: PackedScene

var number_of_cannons = 3

var target_node: Node2D

var turret_node: Node2D
var cannon_next_to_fire: int = 0
var cannon_spawn_points: Array # Of Position2D
var cannon_reloading_speed: float = 1.0
var cannon_loaded_status: Array # Of float, 1 means fully loaded

var cannon_left_indicator: ReloadIndicator
var cannon_center_indicator: ReloadIndicator
var cannon_right_indicator: ReloadIndicator


func _reload_cannons(delta):
	var need_to_reload = false
	var cannon_index = 0
	for cannon_it in range(number_of_cannons):
		cannon_index = (cannon_next_to_fire + cannon_it) % number_of_cannons
		if cannon_loaded_status[cannon_index] < 1.0:
			need_to_reload = true
			break
	if need_to_reload:
		cannon_loaded_status[cannon_index] += cannon_reloading_speed * delta
		cannon_loaded_status[cannon_index] = min(cannon_loaded_status[cannon_index], 1.0)


func _fire_cannon(shot_target: Vector2):
	if cannon_loaded_status[cannon_next_to_fire] == 1.0:
		var spawn_point = cannon_spawn_points[cannon_next_to_fire]
		var created_shell = cannon_shell.instance()
		add_child(created_shell)
		created_shell.global_position = spawn_point.global_position
		created_shell.global_rotation = spawn_point.global_rotation
		created_shell.fire_at(shot_target)
		cannon_loaded_status[cannon_next_to_fire] = 0
		cannon_next_to_fire = (cannon_next_to_fire + 1) % number_of_cannons


func _update_loading_states():
	cannon_left_indicator.set_value(cannon_loaded_status[0])
	cannon_center_indicator.set_value(cannon_loaded_status[1])
	cannon_right_indicator.set_value(cannon_loaded_status[2])


func _ready():
	turret_node = $Cruiser/SpriteTurret
	cannon_spawn_points = [
		$Cruiser/SpriteTurret/CannonLeft,
		$Cruiser/SpriteTurret/CannonMiddle,
		$Cruiser/SpriteTurret/CannonRight
	]
	cannon_loaded_status = [1, 1, 1]
	target_node = $Target

	cannon_left_indicator = $Cursor/CannonLeft
	cannon_center_indicator = $Cursor/CannonCenter
	cannon_right_indicator = $Cursor/CannonRight


func _process(delta):
	turret_node.look_at(target_node.position)

	_reload_cannons(delta)

	if Input.is_action_just_pressed("fire_cannons"):
		_fire_cannon(target_node.position)

	_update_loading_states()
