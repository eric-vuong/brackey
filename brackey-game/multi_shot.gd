extends "res://shop_item.gd"

func _ready() -> void:
	item_name = "Multishot"
	level_max = 4
	upgrade_cost = [3,5,7,10] # List of cost per level
	currency = "yellow"
	description = "+1 per level"
	base_stat = Global.multi_shot
	super()
