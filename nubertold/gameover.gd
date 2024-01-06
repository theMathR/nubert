extends AnimationPlayer

var has_given_up = false
var progress = 0
var to_write = 0
const text = ["You died, but it's OK. Nubert believes in you.","     Then the world was covered in Maice."]

func _ready():
	play("begin")

func _process(delta):
	speed_scale = 1
	if Input.is_action_just_pressed("ui_accept"):
		if current_animation == "begin" and current_animation_position > 1:
			speed_scale = INF
			$Label.text = text[0]
			to_write += 1
			progress = 5
			$Timer.stop()
		elif current_animation=="" and not has_given_up:
			$AudioStreamPlayer.play()
			if $AnimatedSprite2D.animation == "left":
				play("retry")
			else:
				has_given_up = true
				play("giveup")
	if current_animation=="" and not has_given_up:
		if Input.is_action_just_pressed("ui_left"):
			$AudioStreamPlayer.play()
			$AnimatedSprite2D.play("left")
			$Label2.modulate = Color.YELLOW
			$Label3.modulate = Color.WHITE
		elif Input.is_action_just_pressed("ui_right"):
			$AudioStreamPlayer.play()
			$AnimatedSprite2D.play("right")
			$Label2.modulate = Color.WHITE
			$Label3.modulate = Color.YELLOW

func retry():
	get_tree().change_scene_to_file("res://game.tscn")


func _on_timer_timeout():
	if progress < len(text[to_write]):
		$Label.text += text[to_write][progress]
		progress += 1
	else:
		to_write += 1
		progress = 5
		$Timer.stop()
