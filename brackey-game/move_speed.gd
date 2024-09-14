extends "res://shop_item.gd"
func _ready() -> void:
	item_name = "Move Speed"
	level_max = 5
	upgrade_cost = [2,3,4,5,6] # List of cost per level
	currency = "blue"
	description = "How fast you can move\n+10 per level"
	base_stat = Global.player_move_speed
	super()
