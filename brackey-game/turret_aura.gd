extends Area2D
var disabled = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pulse_timer_timeout() -> void:
	if !disabled:
		var inside_aura = get_overlapping_areas()
		if inside_aura:
			$AnimatedSprite2D.play("default")
			for area in inside_aura:
				if area.is_in_group("enemy"):
					print('turret aura damaging enemy')
					area.take_damage(Global.area_turret_dmg)
