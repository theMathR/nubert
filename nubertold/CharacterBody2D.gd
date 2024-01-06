extends CharacterBody2D

signal hit(hp: int)

@export var balloon: PackedScene

const SPEED = 500.0
const JUMP_VELOCITY = -400.0

var has_balloon = false
var balloon_points = 100

var is_dashing = false
var is_groundpounding = false
var is_parrying = false
var is_taunting = false
var can_dash = true

var inv_frames = false

var taunt = 0

var hp = 6

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$Taunt.hide()

func _physics_process(delta):
	if inv_frames:
		$AnimatedSprite2D.modulate.r = 1+sin($InvTimer.time_left*16)/2
		$AnimatedSprite2D.modulate.g = $AnimatedSprite2D.modulate.r
		$AnimatedSprite2D.modulate.b = $AnimatedSprite2D.modulate.r
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if has_balloon:
		velocity.y = move_toward(velocity.y,-SPEED/2,SPEED/10)
		balloon_points -= delta * 20
		if balloon_points < 0:
			balloon_points = 0
			has_balloon = false
			$Nuballoon.scale.y = 0
			var nuballoon = balloon.instantiate()
			nuballoon.position = position
			get_parent().add_child(nuballoon)
	else:
		balloon_points += delta * 10
		if balloon_points > 100:
			balloon_points = 100
	$UI/TextureProgressBar.value = balloon_points
		
	if Input.is_action_just_pressed("parry") and not (is_dashing or is_groundpounding or is_taunting):
		is_parrying = true
		is_taunting = true
		velocity.x=0
		$AnimationPlayer.stop()
		if has_balloon: $Nuballoon.scale = Vector2(3,3)
		$AnimationPlayer.play("taunt")
		$AnimatedSprite2D.play("taunt"+str(taunt+1))
		taunt+=1
		if not $tauntaudio.playing: $tauntaudio.play()
		taunt%=4
		$ParryTimer.start()
		$TauntTimer.start()
	if is_taunting:
		handle_collisions()
		return
	
	if is_dashing:
		velocity.x = is_dashing * SPEED * 10
		handle_collisions()
		return
	
	if is_groundpounding:
		velocity.y += 10000 * delta
		handle_collisions()
		if is_on_floor():
			$AnimationPlayer.play("groundpound_end")
			is_groundpounding = false
			$DashCooldownTimer.start()
		return

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		if Input.is_action_pressed("dash") and can_dash:
			$AnimatedSprite2D.play("dash")
			is_dashing = direction
			velocity.x = direction * SPEED * 4
			$DashTimer.start()
			return
		if direction < 0:
			$AnimatedSprite2D.play("walkl")
		else:
			$AnimatedSprite2D.play("walkr")
		velocity.x = direction * SPEED
	else:
		$AnimatedSprite2D.play("default")
		if inv_frames:
			$AnimatedSprite2D.play("damage")
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("groundpound") and not is_on_floor() and can_dash:
		unballoon()
		$AnimatedSprite2D.play("groundpound")
		is_groundpounding = true
		can_dash = false
	
	if Input.is_action_just_pressed("fly"):
		if unballoon() and balloon_points > 10:
			has_balloon = true
			$AnimationPlayer.play("balloon")
	
	handle_collisions()

func handle_collisions():
	move_and_slide()
	if Input.is_action_just_pressed("ui_accept") and not inv_frames:
		hp -= 1
		emit_signal("hit", hp)


func _on_dash_timer_timeout():
	is_dashing = false
	can_dash = false
	$DashCooldownTimer.start()


func _on_dash_cooldown_timer_timeout():
	can_dash = true

func unballoon():
	if has_balloon:
		has_balloon = false
		$Nuballoon.scale.y = 0
		var nuballoon = balloon.instantiate()
		nuballoon.position = position
		get_parent().add_child(nuballoon)
		return false
	return true


func _on_parry_timer_timeout():
	is_parrying = false


func _on_taunt_timer_timeout():
	is_taunting = false



func _on_inv_timer_timeout():
	inv_frames = false


func _on_hit(hp):
	$InvTimer.start()
	velocity.y -= SPEED/3
	inv_frames = true
	if hp==0:
		get_tree().change_scene_to_file("res://gameover.tscn")
