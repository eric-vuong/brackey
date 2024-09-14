extends "res://base_enemy.gd"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = 50
	speed = 30
	target = "Player"
	tier = 1
	super()
