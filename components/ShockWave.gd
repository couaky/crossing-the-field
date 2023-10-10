class_name ShockWave
extends Area2D


func play(weapon: String):
	if weapon == "Shell":
		$AnimationPlayer.play("ShockWaveShell")
	elif weapon == "Torpedo":
		$AnimationPlayer.play("ShockWaveTorpedo")
	else:
		# Should never happen
		queue_free()


func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
