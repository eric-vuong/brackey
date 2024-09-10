extends Area2D
var core_max = 1000
@export var core_hp = 1000
var is_hitable = true # Switches to false after being hit for a brief period
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	Global.core_pos = self.position
	$CoreHp.max_value = core_max
	$CoreHp.value = core_hp



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_hitable:
		var inside_core = get_overlapping_areas()
		if inside_core:
			# Apply damage. flat for now
			for enemy in inside_core:
				take_damage(10)
			is_hitable = false
			$DamageTimer.set_wait_time(1)
			$DamageTimer.start()

func take_damage(dmg):
	core_hp -= dmg
	$CoreHp.value = core_hp
	if core_hp <= 0:
		print("game over")
		
func _on_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
	print("core entered")
	if area.is_in_group("enemy"):
		pass
	var x = self.get_overlapping_areas()
	print(x)


func _on_damage_timer_timeout() -> void:
	is_hitable = true
