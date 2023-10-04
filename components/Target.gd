extends Sprite


var target_speed: float = 300
var cursor_node: Node2D
var epsilon = 0.01
var min_x_target = 350


func _ready():
	cursor_node = get_node("../Cursor")


func _process(delta):
	var velocity = target_speed * delta
	var distance = position.distance_to(cursor_node.position)
	if distance < epsilon:
		position = cursor_node.position
	else:
		var direction = (cursor_node.position - position).normalized()
		position += direction * min(velocity, distance)
		position.x = max(position.x, min_x_target)
