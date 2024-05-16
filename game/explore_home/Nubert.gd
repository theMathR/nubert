extends CharacterBody2D

const DECELERATION = 150.0
const ACCELERATION = 300.0
const JUMP_VELOCITY = -600.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var cooldown = 0
var tmp = 0

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if not is_on_floor():
		tmp += delta
	elif tmp:
		tmp = 0

	# Handle jump.
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$AnimationPlayer.play("jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	velocity.x -= sign(velocity.x) * DECELERATION * delta
	if abs(velocity.x)<0.1:
		$Skateboard.stop()
	else:
		$Skateboard.flip_h = velocity.x < 0
	if cooldown <= 0 and is_on_floor():
		var stop = clamp(abs(velocity.x)-1500,0,ACCELERATION)
		if Input.is_action_just_pressed("left"):
			if not Input.is_action_just_pressed("right"):
				$Sprite.play("left")
				velocity.x -= ACCELERATION-stop
				cooldown = 0.1
				$Skateboard.play("running")
		elif Input.is_action_just_pressed("right"):
				$Sprite.play("right")
				velocity.x += ACCELERATION-stop
				cooldown = 0.1
				$Skateboard.play("running")
	else:
		cooldown-=delta
	
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i).get_normal()
		if abs(collision.y)<0.1 :
			velocity = collision * ACCELERATION
			cooldown = 0.1
