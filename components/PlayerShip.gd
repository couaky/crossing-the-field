extends Area2D


export var hull_points: int = 1


func _take_damage():
	hull_points -= 1
	if hull_points == 0:
		queue_free()


func _ready():
	connect("area_shape_entered", self, "_on_self_area_shape_entered")


func _on_self_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	_take_damage()
