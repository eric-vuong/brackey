extends "res://base_enemy.gd"

var player_location
var CHARGE_TIME = 1
var CHARGE_COOLDOWN = 5
var CHARGE_DISTANCE = 100
var can_charge = true
var is_charging = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = 200
	speed = 15
	target = "Player"
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func pathing(delta):
	#print('time left: ',$ChargeCooldownTimer.time_left)
	#print('charge timer left: ', $ChargeTimer.time_left)
	if !is_charging:
		if target == "Player":
			direction = self.global_position.direction_to(Global.player_pos)
		elif target == "Core":
			direction = self.global_position.direction_to(Global.core_pos)
		position += direction * speed * delta
	
		if can_charge:
			var in_range = $TargetRange.get_overlapping_areas()
			if in_range:
				for area in in_range:
					if area.is_in_group("player"):
						print("locked on")
						can_charge = false
						is_charging = true
						player_location = Global.player_pos
						#$ChargeTimer.set_wait_time(CHARGE_TIME)
						$ChargeTimer.start(CHARGE_TIME)
						#$ChargeCooldownTimer.set_wait_time(CHARGE_COOLDOWN)
						$ChargeCooldownTimer.start(CHARGE_COOLDOWN)
						return


func _on_charge_timer_timeout() -> void:
	print("charged")
	var direction = self.global_position.direction_to(player_location)
	position += direction * CHARGE_DISTANCE
	is_charging = false
	

func _on_charge_cooldown_timer_timeout() -> void:
	print('charge has cooled down')
	can_charge = true
	#is_charging = false
