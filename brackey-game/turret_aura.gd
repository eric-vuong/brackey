extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pulse_timer_timeout() -> void:
	var inside_aura = get_overlapping_areas()
	print('timeout', inside_aura)
	if inside_aura:
		print('area overlapping enemy')
		for area in inside_aura:
			if area.is_in_group("enemy"):
				area.take_damage(5)
