extends "res://base_enemy.gd"

var player_location
var CHARGE_TIME = 1
var CHARGE_COOLDOWN = 5
var CHARGE_DISTANCE = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = 200
	speed = 15
	target = "Player"
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func pathing(delta):
	print('time left: ',$ChargeCooldownTimer.time_left)
	print('charge timer left: ', $ChargeTimer.time_left)
	if $ChargeTimer.is_stopped():
		if target == "Player":
			direction = self.global_position.direction_to(Global.player_pos)
		elif target == "Core":
			direction = self.global_position.direction_to(Global.core_pos)
		position += direction * speed * delta
	
		if $ChargeCooldownTimer.is_stopped():
			var in_range = $TargetRange.get_overlapping_areas()
			if in_range:
				for area in in_range:
					if area.is_in_group("player"):
						player_location = Global.player_pos
						$ChargeTimer.set_wait_time(CHARGE_TIME)
						$ChargeTimer.start()
						$ChargeCooldownTimer.set_wait_time(CHARGE_COOLDOWN)
						$ChargeCooldownTimer.start()


func _on_charge_timer_timeout() -> void:
	var direction = self.global_position.direction_to(Global.player_pos)
	position += direction * CHARGE_DISTANCE	
	

func _on_charge_cooldown_timer_timeout() -> void:
	print('charge timer timeout')
