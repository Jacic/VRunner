extends Node2D

var score
var highscore

func _ready() -> void:
	$VBoxContainer/FinalScore.text = "FINAL SCORE: " + str(score)
	$VBoxContainer/HighScore.text = "HIGH SCORE: " + str(highscore)

func _process(delta:float) -> void:
	$VBoxContainer/HBoxContainer/YesButton.modulate = Global.curColor
	$VBoxContainer/HBoxContainer/NoButton.modulate = Global.curColor

func restartPressed() -> void:
	if Global.activeLevel.tutorial:
		Global.bgmPlayPosition = Global.activeLevel.getBGMPosition()
		get_tree().change_scene("res://Levels/Tutorial.tscn")
	else:
		Global.bgmPlayPosition = Global.activeLevel.getBGMPosition()
		get_tree().change_scene("res://Levels/PlayScene.tscn")

func MenuPressed() -> void:
	get_tree().change_scene("res://GUI/MainMenu.tscn")
