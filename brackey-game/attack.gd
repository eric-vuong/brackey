extends "res://shop_item.gd"

func _ready() -> void:
	item_name = "Attack"
	level_max = 10
	upgrade_cost = [1,2,2,3,3,4,4,5,5,6] # List of cost per level
	currency = "red"
	description = "+2 Per level"
	base_stat = Global.bullet_damage
	super()
