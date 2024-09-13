extends Sprite2D

# Fill these in for every shop item
var item_name: String
var level_max: int
var upgrade_cost = [] # List of cost per level
var currency: String
var description: String
var base_stat #The inital value of the stat

# Not these
var upgrade_level = 0
func _ready() -> void:
	# Initialize text
	upgrade_level = 0
	if item_name == "Defense": # % case
		$Name.set_text(item_name + ": " + str(base_stat) + "%")
	else:
		$Name.set_text(item_name + ": " + str(base_stat))
	$ProgressBar.max_value = level_max
	$ProgressBar.value = 0
	$Description.set_text(description)
	if len(upgrade_cost) > 0:
		$Cost.set_text(str(upgrade_cost[upgrade_level]))
	else:
		print("Error: No upgrade costs given")
	if currency == "yellow":
		$Currency.texture = preload("res://assets/yellow.png")
	elif currency == "blue":
		$Currency.texture = preload("res://assets/blue.png")
	elif currency == "red":
		$Currency.texture = preload("res://assets/red.png")
	$Level.set_text(str(upgrade_level) + "/" + str(level_max))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_upgrade_pressed() -> void:
	pass

func upgrade():
	get_tree().current_scene.update_money()
	upgrade_level += 1
	# UPGRADE SPECIFIC STAT
	if item_name == "Attack":
		Global.bullet_damage += 1
		$Name.set_text(item_name + ": " + str(Global.bullet_damage))
	elif item_name == "Pierce":
		Global.pierce += 1
		$Name.set_text(item_name + ": " + str(Global.pierce))
	elif item_name == "Attack Speed":
		Global.fire_rate *= 0.9
		$Name.set_text(item_name + ": " + str(Global.fire_rate))
	elif item_name == "Multishot":
		Global.multi_shot += 1
		$Name.set_text(item_name + ": " + str(Global.multi_shot))
	elif item_name == "Defense":
		Global.player_defense += 15
		$Name.set_text(item_name + ": " + str(Global.player_defense) + "%")
	elif item_name == "Move Speed":
		Global.player_move_speed += 5
		$Name.set_text(item_name + ": " + str(Global.player_move_speed))
	else:
		print("Error: Shop item", item_name, "does not exist")
		return
	# Update store elements
	$ProgressBar.value += 1
	if upgrade_level < len(upgrade_cost):
		$Cost.set_text(str(upgrade_cost[upgrade_level]))
		$Level.set_text(str(upgrade_level) + "/" + str(level_max))
	else:
		# Max upgrade
		$Cost.set_text("-")
		$Level.set_text(str(level_max) + "/" + str(level_max))
	
	# Update ALL displayed stat data
	


func _on_upgrade_button_down() -> void:
	# Check if can upgrade
	if upgrade_level < level_max:
		# Check cost
		if currency == "yellow":
			if Global.yellow >= upgrade_cost[upgrade_level]:
				Global.yellow -= upgrade_cost[upgrade_level] # Spend currency
				upgrade()
		elif currency == "red":
			if Global.red >= upgrade_cost[upgrade_level]:
				Global.red -= upgrade_cost[upgrade_level] # Spend currency
				upgrade()
		elif currency == "blue":
			if Global.blue >= upgrade_cost[upgrade_level]:
				Global.blue -= upgrade_cost[upgrade_level] # Spend currency
				upgrade()
