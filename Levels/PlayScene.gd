extends Node2D

export (bool) var tutorial = false
export (int) var baseScrollSpeed:float = 150

var score:int = 0
var highscore:int = 0
var player:Player
var playerXTarget:float
var playerAdjustSpeed:float = 5
var scrollSpeed:float = baseScrollSpeed
var baseGravity:float = 30
var gravity:float = baseGravity
var lastPartEdge = 0
var gameOver

var startingParts = [load("res://LevelParts/Start1.tscn"), load("res://LevelParts/Start2.tscn"),
	load("res://LevelParts/Start3.tscn")]
var levelParts = [load("res://LevelParts/Start1.tscn"), load("res://LevelParts/Start2.tscn"),
	load("res://LevelParts/Start3.tscn"), load("res://LevelParts/Part1.tscn"), load("res://LevelParts/Part2.tscn"),
	load("res://LevelParts/Part3.tscn"), load("res://LevelParts/Part4.tscn"), load("res://LevelParts/Part5.tscn"),
	load("res://LevelParts/Part6.tscn"), load("res://LevelParts/Part7.tscn"), load("res://LevelParts/Part8.tscn"),
	load("res://LevelParts/Part9.tscn"), load("res://LevelParts/Part10.tscn"), load("res://LevelParts/Part11.tscn"),
	load("res://LevelParts/Part12.tscn"), load("res://LevelParts/Part13.tscn"), load("res://LevelParts/Part14.tscn"),
	load("res://LevelParts/Part15.tscn"), load("res://LevelParts/Part16.tscn"), load("res://LevelParts/Part17.tscn")]

func _ready() -> void:
	randomize()
	Global.activeLevel = self
	
	loadScore()
	$BGM.play(Global.bgmPlayPosition)
	
	player = $Player
	playerXTarget = player.position.x
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if !tutorial:
		addStart()

func _process(delta:float) -> void:
	$Camera.position.x += scrollSpeed * delta
	$KillZone.position.x += scrollSpeed * delta
	$KillZoneTop.position.x += scrollSpeed * delta
	$KillZoneBottom.position.x += scrollSpeed * delta
	player.position.x += scrollSpeed * delta
	playerXTarget += scrollSpeed * delta

	$ModulatePrev.modulate = Global.prevColor
	$ModulateCur.modulate = Global.curColor
	
	if player.position.x < playerXTarget:
		player.position.x += playerAdjustSpeed * delta
	if player.position.x > playerXTarget:
		player.position.x = playerXTarget
	
	$Background.position.x = $Camera.position.x - 2
	
	if !tutorial:
		handleLevel()
	
	if $Player.dead:
		handleGameOver(delta)
	else:
		score += floor(scrollSpeed * delta)
		$CanvasLayer/ScoreLabel.text = "SCORE: " + str(score)

func handleLevel():
	if $Camera.position.x + (get_viewport_rect().size.x * $Camera.zoom.x) > lastPartEdge:
		addPart()
	
	var speedUp = $Camera.position.x / 500
	scrollSpeed = baseScrollSpeed + speedUp
	gravity = baseGravity + (baseGravity * speedUp / baseScrollSpeed)

func addStart():
	var part = startingParts[randi() % startingParts.size()].instance()
	part.position.x = lastPartEdge
	lastPartEdge += part.partWidth
	add_child(part)

func addPart():
	var flipPart = randf() < 0.5
	var partNum = randi() % levelParts.size()
	var part = levelParts[partNum].instance()
	part.position.x = lastPartEdge
	lastPartEdge += part.partWidth
	
	if flipPart:
		part.scale.y *= -1
		part.position.y = ($Camera.position.y + get_viewport_rect().size.y) * $Camera.zoom.y
	
	add_child(part)

func handleGameOver(delta:float):
	if gameOver.position.y > 0:
		gameOver.position.y -= 150 * delta

func getCamera():
	return $Camera

func getBGMPosition() -> float:
	return $BGM.get_playback_position()

func loadScore():
	var file = File.new()
	if !file.file_exists("user://vrunnerscore"):
		return
	
	file.open("user://vrunnerscore", File.READ)
	if file.get_len() == 8:	#a single 64bit value
		highscore = file.get_64()
	
	file.close()

func saveScore():
	var file = File.new()
	file.open("user://vrunnerscore", File.WRITE)
	file.store_64(highscore)
	file.close()

func _on_Player_died() -> void:
	if !tutorial:
		if score > highscore:
			highscore = score
			saveScore()
	gameOver = load("res://GUI/GameOver.tscn").instance()
	gameOver.position.y = ($Camera.position.y + get_viewport_rect().size.y)
	gameOver.score = score
	gameOver.highscore = highscore
	$CanvasLayer.add_child(gameOver)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
