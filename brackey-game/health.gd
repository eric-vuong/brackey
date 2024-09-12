extends "res://shop_item.gd"

func _ready() -> void:
	item_name = "Defense"
	level_max = 5
	upgrade_cost = [2,4,6,8,10] # List of cost per level
	currency = "blue"
	description = "Reduces damage you can take"
	base_stat = Global.player_defense
	super()
