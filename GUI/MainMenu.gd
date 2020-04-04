extends Node2D

func _ready() -> void:
	Global.initColors()
	Global.bgmPlayPosition = 0.0

func _process(delta: float) -> void:
	$CenterContainer/VBoxContainer/HBoxContainer/PlayButton.modulate = Global.curColor
	$CenterContainer/VBoxContainer/HBoxContainer/TutorialButton.modulate = Global.curColor

func _on_button_pressed(button:String) -> void:
	match button:
		"play":
			get_tree().change_scene("res://Levels/PlayScene.tscn")
		"tutorial":
			get_tree().change_scene("res://Levels/Tutorial.tscn")
