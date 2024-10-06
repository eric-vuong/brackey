extends "res://base_enemy.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = 60
	speed = 120
	target = "Core"
	tier = 2
	droprate = 2
	super() # Calls base class ready
