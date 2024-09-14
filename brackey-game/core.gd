extends Area2D
signal gameover
signal core_hurt # Hud will update health bar and show warning
#var core_max = 1000
#@export var core_hp = 1000
var is_hitable = true # Switches to false after being hit for a brief period
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.core_pos = self.position + Vector2(0, -30)
	# Core hp moved to global
	
	#core_hp = core_max
	#$CoreHp.max_value = core_max
	#$CoreHp.value = core_hp

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_hitable:
		var inside_core = get_overlapping_areas()
		if inside_core:
			# Apply damage. flat for now
			var just_player = true # Ignore if its ONLY the player in here
			for enemy in inside_core:
				if enemy.is_in_group("enemy"):
					take_damage(10)
					just_player = false
			if just_player:
				return
			is_hitable = false
			$DamageTimer.set_wait_time(1)
			$DamageTimer.start()

func take_damage(dmg):
	Global.core_hp -= dmg
	#$CoreHp.value = core_hp
	
	# Emit signal
	core_hurt.emit()
	if Global.core_hp <= 0:
		gameover.emit()
		
# Detect player to open shop
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		Global.can_shop = true


func _on_damage_timer_timeout() -> void:
	is_hitable = true


func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		Global.can_shop = false
		owner.close_shop()
