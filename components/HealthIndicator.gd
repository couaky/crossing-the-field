class_name HealthIndicator
extends Node2D


var max_value: int = 1
var current_value: int = 1

var full_color = Color(1, 1, 1)
var empty_color = Color(0.2, 0.2, 0.2)

var indicators: Array # Of ColorRect


func set_max_value(new_max_value: int):
	if new_max_value != max_value:
		max_value = new_max_value
		current_value = max_value
		for indicator in indicators:
			indicator.queue_free()
		indicators.clear()
		for index in range(max_value):
			var new_indicator = ColorRect.new()
			add_child(new_indicator)
			indicators.push_back(new_indicator)
			new_indicator.rect_size = Vector2(20, 20)
			new_indicator.rect_position = Vector2(-index * 30, -10)
			new_indicator.color = full_color


func set_value(new_current_value):
	if new_current_value != current_value:
		current_value = new_current_value
		for index in range(max_value):
			var indicator = indicators[index] as ColorRect
			indicator.color = full_color if index < current_value else empty_color


func _ready():
	indicators = [$InitialRect]
