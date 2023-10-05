extends Node2D


export var cannon_shell: PackedScene


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

var number_of_cannons = 3
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
	if cruiser_alive:
		cannon_left_indicator.set_value(cannon_loaded_status[0])
		cannon_center_indicator.set_value(cannon_loaded_status[1])
		cannon_right_indicator.set_value(cannon_loaded_status[2])


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


func _ready():
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


func _process(delta):
	if cruiser_alive:
		turret_node.look_at(target_node.position)
		_reload_cannons(delta)
		if Input.is_action_just_pressed("fire_cannons"):
			_fire_cannon(target_node.position)

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
	_check_game_over()


func _on_EscortA_hit(health):
	escort_A_health.set_value(health)


func _on_EscortB_destroyed():
	escort_B_alive = false
	escort_B_health.set_value(0)
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
