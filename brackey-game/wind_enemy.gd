extends "res://base_enemy.gd"
func _ready():
	
	health = 20
	speed = 80
	target = "Core"
	super() # Calls base class ready
