extends TextureRect

var text = []
var line = ""
var ch = 0
var l = 0
var t = 0

func _process(delta):
	if ch < len(line):
		t += delta
		$AudioStreamPlayer.play()
		if t > 0.025:
			t = 0
			$Label.text += line[ch]
			ch += 1
		if Input.is_action_just_pressed("x"):
			$Label.text = line
			ch = len(line)
	else:
		if Input.is_action_just_pressed("validate"):
			l += 1
			$Label.text = ""
			ch = 0
			if l < len(text):
				line = text[l]
			else:
				hide()
				line = ""
				get_tree().paused = false

func start(t):
	$"../../Nubert/Label".hide()
	show()
	get_tree().paused = true
	text = t
	ch = 0
	l = 0
	line = t[0]
