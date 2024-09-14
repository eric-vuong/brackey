extends "res://base_enemy.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = 90
	speed = 80
	target = "Core"
	drops = "red"
	tier = 2
	super()
