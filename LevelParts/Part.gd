extends Node2D

export (int) var partWidth = 0

var camera

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = get_parent().getCamera()

func _process(delta:float):
	$ModulatePrev.modulate = Global.prevColor
	$ModulateCur.modulate = Global.curColor
	if position.x + partWidth < camera.position.x:
			queue_free()
