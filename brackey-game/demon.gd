extends "res://base_enemy.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = 100
	speed = 70
	target = "Core"
	drops = "red"
	tier = 2
	droprate = 2
	super()
