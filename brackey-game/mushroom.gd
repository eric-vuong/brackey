extends "res://base_enemy.gd"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = 40
	speed = 30
	target = "Player"
	super()
