extends Area2D

func _ready():
	$AnimationPlayer.play("spin")

func _on_KillArea_body_entered(body):
	if body.has_method('takeDamage'):
		body.takeDamage()
