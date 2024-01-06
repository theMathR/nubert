extends Control

@onready var player = get_parent().get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("a")

func play(anim,nostatic = false):
	if $AnimatedSprite2D.animation != anim:
		if ($AnimatedSprite2D.animation == "static" and $AnimatedSprite2D.frame > 0) or $AnimatedSprite2D.animation == "dash":
			$AnimatedSprite2D.play(anim)
		else:
			$AnimatedSprite2D.play("static")

func _process(d):
	if player.is_groundpounding:
		play("gp");return
	if player.inv_frames:
		play("damage");return
	if player.has_balloon:
		play("fly");return
	if Input.is_action_pressed("left"):
		if $AnimatedSprite2D.animation in ["right", "default"]: $AnimatedSprite2D.play("left")
		play("left");return
	elif Input.is_action_pressed("right"):
		if $AnimatedSprite2D.animation in ["left", "default"]: $AnimatedSprite2D.play("right")
		play("right");return
	if $AnimatedSprite2D.animation in ["right", "left"]: $AnimatedSprite2D.play("default")
	play("default")
