extends "res://base_enemy.gd"
func _ready():
	
	health = 30
	speed = 60
	target = "Player"
	tier = 1
	droprate = 3
	super() # Calls base class ready
