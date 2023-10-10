class_name TorpedoPlasma
extends Area2D


func _ready():
	$AnimationPlayer.play("Plasma")


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
