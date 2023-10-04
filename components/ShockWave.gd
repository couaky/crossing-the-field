class_name ShockWave
extends Area2D


func _ready():
	$AnimationPlayer.play("ShockWaveExpand")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "ShockWaveExpand":
		queue_free()
