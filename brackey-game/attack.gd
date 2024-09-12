extends "res://shop_item.gd"

func _ready() -> void:
	item_name = "Attack"
	level_max = 10
	upgrade_cost = [1,2,3,4,5,6,7,8,9,10] # List of cost per level
	currency = "red"
	description = "Damage done per attack"
	base_stat = Global.bullet_damage
	super()
