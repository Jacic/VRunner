extends Node2D

const MISSILE = preload("res://Objects/Missile.tscn")
var reload_rate = 2.0
var can_fire = true

func _ready():
	pass

func spawn(node, position):
	var instance = node.instance()
	var scene_root = Global.activeLevel
	instance.global_position = position
	instance.parent = $Weapon
	scene_root.get_node("ModulatePrev").add_child(instance)

func _physics_process(delta):
	if $Weapon/RayCast2D.is_colliding():
		var col = $Weapon/RayCast2D.get_collider()
		if col is Player:
			if !col.dead:
				fire()

func fire():
	if can_fire:
		can_fire = false
		spawn(MISSILE, $Weapon/Position2D.global_position)
		$ShootSound.play()
		yield(get_tree().create_timer(reload_rate), "timeout")
		can_fire = true

func _on_Area2D_body_entered(body: Node) -> void:
	if body.has_method('takeDamage'):
		body.takeDamage()
