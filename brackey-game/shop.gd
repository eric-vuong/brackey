extends CanvasLayer
var bonuses = ["Run and Gun", "More Shots", "Power Shot", "Rapid Fire", "Boomerang", "Ice Shot"]
var i: int
var bonus: String
var bonus_desc: String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	hide_bonus(false)
	bonuses.shuffle()
	i = -1 # Will start at 0
	reset_bonus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	if Global.yellow >= 10 and Global.red >= 10 and Global.blue >= 10:
		Global.red -= 10
		Global.blue -= 10
		Global.yellow -= 10
		get_tree().current_scene.update_money()
	else:
		return
	hide_bonus(true)
	i += 1
	# Choose a bonus
	if i == len(bonuses): # Re shuffle
		i = 0
		bonuses.shuffle()
	bonus = bonuses[i]
	print("Bonus enabled:", bonus)
	# Activate bonus effect
	if bonus == "Run and Gun":
		Global.run_and_gun = true
		Global.bullet_damage_boost = 5
		bonus_desc = "Attack while sprinting. More damage"
	elif bonus == "More Shots":
		Global.multi_bonus = 4
		bonus_desc = "Fire more shots"
	elif bonus == "Power Shot":
		Global.bullet_damage_boost = 10
		Global.bullet_size_mod = 4
		bonus_desc = "Fire bigger and stronger shots"
	elif bonus == "Rapid Fire":
		Global.rapid_fire_mod = 0.7
		bonus_desc = "Shoot faster when not moving"
	elif bonus == "Boomerang":
		Global.return_shots = true
		bonus_desc = "Shots fly back"
	elif bonus == "Ice Shot":
		Global.slowing_shot = true
		bonus_desc = "Shots slow enemies"
	$BoonName.text = bonus
	$BoonEffect.text = bonus_desc
	
func hide_bonus(to_hide):
	if to_hide:
		$Button.hide()
		$Red.hide()
		$Yellow.hide()
		$Blue.hide()
		$BonusCost.hide()
		
		$BoonName.show()
		$BoonEffect.show()
	else:
		$Button.show()
		$Red.show()
		$Yellow.show()
		$Blue.show()
		$BonusCost.show()
		
		$BoonName.hide()
		$BoonEffect.hide()
func reset_bonus():
	Global.bullet_size_mod = 1
	Global.rapid_fire_mod = 1
	Global.run_and_gun = false
	Global.return_shots = false
	Global.multi_bonus = 0
	Global.bullet_damage_boost = 0
	Global.slowing_shot = false
