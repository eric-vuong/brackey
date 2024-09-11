extends "res://base_enemy.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = 30
	speed = 30
	target = "Player"
	super()
