extends "res://base_enemy.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = 90
	speed = 60
	target = "Player"
	drops = "blue"
	tier = 2
	droprate = 2
	super()
