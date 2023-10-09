extends Node2D


export var cannon_shell_scene: PackedScene
export var explosion_scene: PackedScene
export var torpedo_scene: PackedScene


signal game_over


var cruiser_alive: bool = true
var escort_A_alive: bool = true
var escort_B_alive: bool = true
var cargo_A_alive: bool = true
var cargo_B_alive: bool = true
var cargo_C_alive: bool = true
var cargo_D_alive: bool = true

var escort_A_health: HealthIndicator
var cruiser_health: HealthIndicator
var escort_B_health: HealthIndicator

var target_node: Node2D
var turret_node: Node2D
var cursor_node: Node2D

var number_of_cannons = 3
var cannon_next_to_fire: int = 0
var cannon_spawn_points: Array # Of Position2D
var cannon_reloading_speed: float = 1.0
var cannon_loaded_status: Array # Of float, 1 means fully loaded

var cannon_left_indicator: ReloadIndicator
var cannon_center_indicator: ReloadIndicator
var cannon_right_indicator: ReloadIndicator

var min_x_torpedo = 400
var number_of_tubes = 2
var torpedo_reloading_speed = 1.0
var tube_A_next_to_fire = 0
var tube_A_spawn_points: Array # Of Position2D
var torpedo_A_loaded_status: Array # Of float, 1 means fully loaded
var tube_B_next_to_fire = 0
var tube_B_spawn_points: Array # Of Position2D
var torpedo_B_loaded_status: Array # Of float, 1 means fully loaded

var tube_A1_indicator: ReloadIndicator
var tube_A2_indicator: ReloadIndicator
var tube_B1_indicator: ReloadIndicator
var tube_B2_indicator: ReloadIndicator


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

		var created_shell = cannon_shell_scene.instance() as CannonShell
		add_child(created_shell)
		created_shell.global_position = spawn_point.global_position
		created_shell.global_rotation = spawn_point.global_rotation
		created_shell.fire_at(shot_target)
		cannon_loaded_status[cannon_next_to_fire] = 0
		cannon_next_to_fire = (cannon_next_to_fire + 1) % number_of_cannons

		var flash_effect = explosion_scene.instance() as Explosion
		add_child(flash_effect)
		flash_effect.global_position = spawn_point.global_position
		flash_effect.cannon_fire()


func _update_loading_states():
	if cruiser_alive:
		cannon_left_indicator.set_value(cannon_loaded_status[0])
		cannon_center_indicator.set_value(cannon_loaded_status[1])
		cannon_right_indicator.set_value(cannon_loaded_status[2])

	if escort_A_alive:
		tube_A1_indicator.set_value(torpedo_A_loaded_status[0])
		tube_A2_indicator.set_value(torpedo_A_loaded_status[1])

	if escort_B_alive:
		tube_B1_indicator.set_value(torpedo_B_loaded_status[0])
		tube_B2_indicator.set_value(torpedo_B_loaded_status[1])


func _check_game_over():
	var all_ships = [
		cruiser_alive,
		escort_A_alive,
		escort_B_alive,
		cargo_A_alive,
		cargo_B_alive,
		cargo_C_alive,
		cargo_D_alive
	]
	if not true in all_ships:
		print("game over...")
		emit_signal("game_over")


func _reload_torpedo_A(delta):
	_reload_torpedo(tube_A_next_to_fire, torpedo_A_loaded_status, delta)


func _reload_torpedo_B(delta):
	_reload_torpedo(tube_B_next_to_fire, torpedo_B_loaded_status, delta)


func _reload_torpedo(tube_next_to_fire: int, torpedo_loaded_status: Array, delta: float):
	var need_to_reload = false
	var tube_index = 0
	for tube_it in range(number_of_tubes):
		tube_index = (tube_next_to_fire + tube_it) % number_of_tubes
		if torpedo_loaded_status[tube_index] < 1.0:
			need_to_reload = true
			break
	if need_to_reload:
		torpedo_loaded_status[tube_index] += torpedo_reloading_speed * delta
		torpedo_loaded_status[tube_index] = min(torpedo_loaded_status[tube_index], 1.0)


func _fire_torpedo_A():
	if _fire_torpedo(torpedo_A_loaded_status, tube_A_spawn_points, tube_A_next_to_fire):
		torpedo_A_loaded_status[tube_A_next_to_fire] = 0
		tube_A_next_to_fire = (tube_A_next_to_fire + 1) % number_of_tubes


func _fire_torpedo_B():
	if _fire_torpedo(torpedo_B_loaded_status, tube_B_spawn_points, tube_B_next_to_fire):
		torpedo_B_loaded_status[tube_B_next_to_fire] = 0
		tube_B_next_to_fire = (tube_B_next_to_fire + 1) % number_of_tubes


func _fire_torpedo(torpedo_loaded_status: Array, tube_spawn_points: Array, tube_next_to_fire: int) -> bool:
	if torpedo_loaded_status[tube_next_to_fire] == 1.0:
		var torpedo_tube = tube_spawn_points[tube_next_to_fire]
		var target = cursor_node.global_position
		if target.x >= min_x_torpedo:
			var new_torpedo = torpedo_scene.instance() as Torpedo
			add_child(new_torpedo)
			new_torpedo.global_position = torpedo_tube.global_position
			new_torpedo.target = target
			return true
	return false


func _ready():
	cursor_node = $Cursor
	escort_A_health = $Cursor/EscortAHealth
	cruiser_health = $Cursor/CruiserHealth
	escort_B_health = $Cursor/EscortBHealth

	escort_A_health.set_max_value(2)
	cruiser_health.set_max_value(3)
	escort_B_health.set_max_value(2)

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

	tube_A_spawn_points = [
		$EscortA/Tube1,
		$EscortA/Tube2
	]
	torpedo_A_loaded_status = [1, 1]

	tube_B_spawn_points = [
		$EscortB/Tube1,
		$EscortB/Tube2
	]
	torpedo_B_loaded_status = [1, 1]

	tube_A1_indicator = $Cursor/TubeA1
	tube_A2_indicator = $Cursor/TubeA2
	tube_B1_indicator = $Cursor/TubeB1
	tube_B2_indicator = $Cursor/TubeB2


func _process(delta):
	if cruiser_alive:
		turret_node.look_at(target_node.position)
		_reload_cannons(delta)
		if Input.is_action_just_pressed("fire_cannons"):
			_fire_cannon(target_node.position)

	if escort_A_alive:
		_reload_torpedo_A(delta)
		if Input.is_action_just_pressed("fire_torpedo_A"):
			_fire_torpedo_A()

	if escort_B_alive:
		_reload_torpedo_B(delta)
		if Input.is_action_just_pressed("fire_torpedo_B"):
			_fire_torpedo_B()

	_update_loading_states()


func _on_Cruiser_destroyed():
	cruiser_alive = false
	cannon_left_indicator.set_value(0.0)
	cannon_center_indicator.set_value(0.0)
	cannon_right_indicator.set_value(0.0)
	cruiser_health.set_value(0)
	_check_game_over()


func _on_Cruiser_hit(health):
	cruiser_health.set_value(health)


func _on_EscortA_destroyed():
	escort_A_alive = false
	escort_A_health.set_value(0)
	tube_A1_indicator.set_value(0)
	tube_A2_indicator.set_value(0)
	_check_game_over()


func _on_EscortA_hit(health):
	escort_A_health.set_value(health)


func _on_EscortB_destroyed():
	escort_B_alive = false
	escort_B_health.set_value(0)
	tube_B1_indicator.set_value(0)
	tube_B2_indicator.set_value(0)
	_check_game_over()


func _on_EscortB_hit(health):
	escort_B_health.set_value(health)


func _on_CargoA_destroyed():
	cargo_A_alive = false
	_check_game_over()


func _on_CargoB_destroyed():
	cargo_B_alive = false
	_check_game_over()


func _on_CargoC_destroyed():
	cargo_C_alive = false
	_check_game_over()


func _on_CargoD_destroyed():
	cargo_D_alive = false
	_check_game_over()
