extends Area2D


export var hull_points: int = 1


signal destroyed
signal hit(health)


func _destroy():
	queue_free()
	emit_signal("destroyed")


func _take_damage():
	hull_points -= 1
	if hull_points == 0:
		_destroy()
	else:
		emit_signal("hit", hull_points)


func _ready():
	connect("area_shape_entered", self, "_on_self_area_shape_entered")


func _on_self_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	call_deferred("_take_damage")
