extends Area2D
var disabled = true
var upgraded = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func upgrade():
	#$AnimatedSprite2D.play("upgraded")
	upgraded = true
func degrade():
	$AnimatedSprite2D.play("default")
	upgraded = false

func _on_pulse_timer_timeout() -> void:
	if !disabled:
		var inside_aura = get_overlapping_areas()
		if inside_aura:
			if upgraded:
				$AnimatedSprite2D.play("upgraded")
			else:
				$AnimatedSprite2D.play("default")
			$AuraPulse.play()
			for area in inside_aura:
				if area.is_in_group("enemy"):
					#print('turret aura damaging enemy')
					if upgraded:
						area.take_damage(Global.area_turret_dmg2)
					else:
						area.take_damage(Global.area_turret_dmg)
