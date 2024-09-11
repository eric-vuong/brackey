extends "res://base_enemy.gd"
func _ready():
	
	health = 30
	speed = 60
	target = "Player"
	super() # Calls base class ready
