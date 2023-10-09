class_name Torpedo
extends Area2D


var target: Vector2 = Vector2.ZERO

var initial_speed: Vector2 = Vector2(50.0, 0.0)
var max_speed: float = 300.0
# Time before the torpedo start to engage_
var safe_time_s: float = 1.0
var rotation_speed: float = 90.0 # Deg per seconds
var lateral_correction: float = 50.0
var forward_thrust: float = 100.0

var current_velocity: Vector2
enum EngageState {SAFE = 1, ACQUIRE = 2, ENGAGE = 3}
var current_state: int = EngageState.SAFE

var angle_epsilon: float = 0.017 # radians
var min_dist_to_detonate: float = 5.0


func _schedule_engage():
	current_state = EngageState.SAFE
	yield(get_tree().create_timer(safe_time_s), "timeout")
	current_state = EngageState.ACQUIRE


func _do_aquisition(delta):
	var forward_vector = Vector2.RIGHT.rotated(rotation)
	var target_vector = (target - position).normalized()
	var angle_to_target = forward_vector.angle_to(target_vector)
	#print("Angle to target: {0}".format([angle_to_target]))
	if abs(angle_to_target) < angle_epsilon:
		current_state = EngageState.ENGAGE
	if angle_to_target > 0:
		# Turn Right
		var angle_turn = (rotation_speed / 360.0 * 2 * PI) * delta
		rotate(min(angle_turn, angle_to_target))
	else:
		# Turn Left
		var angle_turn = (-rotation_speed / 360.0 * 2 * PI) * delta
		rotate(max(angle_turn, angle_to_target))


func _lateral_correction(delta):
	var local_velocity = current_velocity.rotated(-rotation)
	var lateral_mouvement = local_velocity.y
	var current_lateral_correction = min(abs(lateral_mouvement), lateral_correction * delta)
	if lateral_mouvement > 0:
		current_velocity += Vector2.UP.rotated(rotation) * current_lateral_correction
	else:
		current_velocity += Vector2.DOWN.rotated(rotation) * current_lateral_correction


func _thrust_forward(delta):
	pass	# Limit velocity to max velocity
	var forward_vector = Vector2.RIGHT.rotated(rotation)
	current_velocity += forward_vector * forward_thrust * delta
	if current_velocity.length() > max_speed:
		current_velocity.limit_length(max_speed)


func _do_engagement(delta):
	_do_aquisition(delta)
	_lateral_correction(delta)
	_thrust_forward(delta)


func _detonate():
	queue_free()


func _ready():
	current_velocity = initial_speed
	_schedule_engage()


func _process(delta):
	if current_state == EngageState.ACQUIRE:
		_do_aquisition(delta)
	elif current_state == EngageState.ENGAGE:
		_do_engagement(delta)

	# Trigger explosition if at target
	var next_distance = (current_velocity * delta).length()
	var distance_to_target = position.distance_to(target)
	if next_distance > distance_to_target:
		next_distance = distance_to_target

	if distance_to_target < min_dist_to_detonate:
		_detonate()
	else:
		position += current_velocity * delta
