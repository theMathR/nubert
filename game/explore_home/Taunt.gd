extends Sprite2D

func _process(delta):
	if Input.is_action_just_pressed("taunt") and not get_tree().paused:
		$AudioStreamPlayer.play()
		get_tree().paused = true
		position = $"../Sprite".position
		$AnimationPlayer.play("taunt")

func stop():
	get_tree().paused = false
