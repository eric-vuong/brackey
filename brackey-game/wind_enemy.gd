extends "res://base_enemy.gd"
func _ready():
	
	health = 20
	speed = 80
	target = "Core"
	tier = 1
	droprate = 3
	super() # Calls base class ready
