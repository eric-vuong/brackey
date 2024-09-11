extends "res://base_enemy.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = 80
	speed = 40
	target = "Core"
	super()
