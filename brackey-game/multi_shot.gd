extends "res://shop_item.gd"

func _ready() -> void:
	item_name = "Multishot"
	level_max = 4
	upgrade_cost = [5,10,15,20] # List of cost per level
	currency = "yellow"
	description = "How many projectiles are launched on attack"
	base_stat = Global.multi_shot
	super()
