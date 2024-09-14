extends "res://shop_item.gd"

func _ready() -> void:
	item_name = "Attack Speed"
	level_max = 5
	upgrade_cost = [2,4,5,6,8] # List of cost per level
	currency = "yellow"
	description = "Delay between attacks\n-20% per level"
	base_stat = Global.fire_rate
	super()
