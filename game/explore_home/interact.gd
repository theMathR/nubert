extends Area2D

@export var lines = ['placeholder']

var player_in = false
@onready var player = $"../../Nubert"

func _process(delta):
	print(player_in)
	if player_in and Input.is_action_just_pressed("validate") and player.velocity.length_squared() < 1000000:
		player.velocity = Vector2.ZERO
		$"../../CanvasLayer/TextureRect".start(lines)
		


func _on_area_entered(area):
	player_in = true
	player.get_child(6).show()



func _on_area_exited(area):
	player_in = false
	player.get_child(6).hide()
