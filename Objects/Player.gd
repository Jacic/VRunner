extends KinematicBody2D

signal died

class_name Player

const aliveImage = preload("res://art/player.png")
const deadImage = preload("res://art/player_dead.png")

var speed = 50
var stopping_friction = 0.6
var running_friction = 0.9
var gravityDir:Vector2 = Vector2(0, 1)
var dead = false

var vel = Vector2()
var maxVelocity:Vector2 = Vector2(800, 800)

func _ready():
	pass

func takeDamage():
	if !dead:
		dead = true
		emit_signal("died")

func collectPickup(value:int):
	Global.activeLevel.score += value
	$PickupSound.play()

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(delta:float):
	if dead:
		modulate.a -= delta
	else:
		modulate = Global.prevColor

func _physics_process(delta):
	input(delta)
	friction()
	gravity()
	vel = move_and_slide(vel, Vector2.UP)

func input(delta):
	if dead:
		return
	
	if Input.is_action_just_pressed("flip"):
		if is_on_floor() || is_on_ceiling():
			gravityDir.y *= -1
			$Sprite.flip_v = !$Sprite.flip_v

func friction():
	var running = Input.is_action_pressed("left") or Input.is_action_pressed("right")
	if not running and is_on_floor():
		vel.x *= stopping_friction
	else:
		vel.x *= running_friction

func gravity():
	vel.y += Global.activeLevel.gravity * gravityDir.y
	if vel.y > abs(maxVelocity.y):
		vel.y = maxVelocity.y	#clamp falling speed

func playerDied() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite.texture = deadImage
	$DeathSound.play()
