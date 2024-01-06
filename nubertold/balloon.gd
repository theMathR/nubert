extends Sprite2D

@onready var v = Vector2.UP.rotated(randf()-0.5)*500

func _process(delta):
	position += v * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
