extends Area2D

export (int) var value = 500
export (float) var spawnChance = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if randf() > spawnChance:
		call_deferred("queue_free")

func _process(delta: float) -> void:
	pass

func _on_Bonus_body_entered(body:Node) -> void:
	if body is Player:
		body.collectPickup(value)
		call_deferred("queue_free")
