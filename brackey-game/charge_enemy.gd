extends "res://base_enemy.gd"

var CHARGE_WARMUP = 1
var CHARGE_COOLDOWN = 3
var CHARGE_SPEED = 1500
var CHARGE_DURATION = 0.175
var BASE_SPEED = 20
var charge_direction
var can_charge = true
var is_charging = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("default")
	health = 300
	speed = BASE_SPEED
	target = "Player"
	droprate = 1
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func pathing(delta):

	#if not charging walk or charge lock onto player if in range
	if !is_charging:
		if target == "Player":
			direction = self.global_position.direction_to(Global.player_pos)
		elif target == "Core":
			direction = self.global_position.direction_to(Global.core_pos)
		position += direction * speed * delta
	
		#check if player is nearby
		if can_charge:
			var in_range = $TargetRange.get_overlapping_areas()
			if in_range:
				for area in in_range:
					if area.is_in_group("player"):
						print("locked on")
						can_charge = false
						is_charging = true
						speed = 0 #stand still while charging up
						charge_direction = self.global_position.direction_to(Global.player_pos)
						$ChargeTimer.start(CHARGE_WARMUP)
						$ChargeCooldownTimer.start(CHARGE_COOLDOWN)
						$AnimatedSprite2D.play("charge")
						return
	else: #otherwise execute charge - speed is 0 or CHARGE_SPEED depending on stage of cast
		position += charge_direction * speed * delta
		
		
		

func _on_charge_timer_timeout() -> void:
	print("charging")
	speed = CHARGE_SPEED
	$ChargeDuration.start(CHARGE_DURATION)
	

func _on_charge_cooldown_timer_timeout() -> void:
	print('charge has cooled down')
	can_charge = true


func _on_charge_duration_timeout() -> void:
	print('charge finished')
	is_charging = false
	speed = BASE_SPEED
	$AnimatedSprite2D.play("default")
