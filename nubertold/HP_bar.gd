extends Control

@onready var icons = [$HP1,$HP2,$HP3,$HP4,$HP5,$HP6]

func _ready():
	for i in icons:
		i.show()
		i.play('default')


func _on_nubert_hit(hp):
	$AnimationPlayer.play(str(hp))
