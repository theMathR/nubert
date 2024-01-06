extends CanvasLayer

var sound: AudioStream
var anim = "default"
var text = "* The pain itself is reason why."
var progress = 0

func begin_talk(_anim: String, _text: String):
	anim = _anim
	text = _text
	progress = 1
	$Box/TextureRect.play(anim)
	$Timer.start()
	if anim == "default": 
		$Box/TextureRect.hide()
		$Box/Label.size = Vector2(675, 150)
		$Box/Label.position = Vector2(14.8, 11.6)
	else:
		$Box/TextureRect.show()
		$Box/Label.size = Vector2(500, 150)
		$Box/Label.position = Vector2(77.6, 11.6)
	$Box/Label.text = ""

func _on_timer_timeout():
	$Box/Label.text = text.left(progress)
	if progress == text.length():
		$Timer.stop()
		$Box/TextureRect.stop()
	progress+=1
