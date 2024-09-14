extends "res://shop_item.gd"

func _ready() -> void:
	item_name = "Pierce"
	level_max = 3
	upgrade_cost = [3,5,7] # List of cost per level
	currency = "red"
	description = "Attacks penetrate enemies\n+1 per level"
	base_stat = Global.pierce
	super()
