class_name ReloadIndicator
extends Node2D


var value: float = 1.0 # Should go [0,1]

var indicator_radius: float = 20.0
var indicator_background_color: Color = Color(0.2, 0.2, 0.2)
var indicator_loading_color: Color = Color(0.5, 0.5, 0.5)
var indicator_loaded_color: Color = Color(1.0, 1.0, 1.0)


func set_value(new_value: float):
	if new_value != value:
		value = new_value
		update()


func _draw():
	var indicator_color = indicator_loading_color if value != 1.0 else indicator_loaded_color
	draw_circle_arc_poly(Vector2.ZERO, indicator_radius, 0, 360.0, indicator_background_color)
	draw_circle_arc_poly(Vector2.ZERO, indicator_radius, 0, 360.0 * value, indicator_color)


func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()
	points_arc.push_back(center)
	var colors = PoolColorArray([color])

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)
