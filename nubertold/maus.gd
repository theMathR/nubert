extends CharacterBody2D


const SPEED = 700.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = -1

func _ready():
	$AnimatedSprite2D.play("default")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if is_on_wall():
		direction *= -1
		$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h

	velocity.x = direction * SPEED

	move_and_slide()
