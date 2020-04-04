extends Node2D

func _ready():
	pass

func _on_KillArea_body_entered(body:Node):
	if body.has_method('takeDamage'):
		body.takeDamage()
