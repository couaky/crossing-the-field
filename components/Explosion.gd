class_name Explosion
extends Node2D


func shell_explosion():
	$AnimationPlayer.play("ShellExplosion")


func asteroid_explosion():
	$AnimationPlayer.play("AsteroidExplosion")


func cannon_fire():
	$AnimationPlayer.play("ShellFire")


func torpedo_explosion():
	$AnimationPlayer.play("TorpedoExplosion")


func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
