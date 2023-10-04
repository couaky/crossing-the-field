class_name Explosion
extends Node2D


func shell_explosion():
	$Sprite.scale = Vector2(0.2, 0.2)
	$AnimationPlayer.play("ShellExplosion")


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
