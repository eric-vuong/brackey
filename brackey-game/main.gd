extends Node2D
var wind = preload("res://wind_enemy.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	$PauseMenu.parent = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		# PAUSE GAME
		$PauseMenu.pause()

# temp mob spawning func
func _on_mob_timer_timeout() -> void:
	var mob = wind.instantiate()
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	mob.position = mob_spawn_location.position
	add_child(mob)

# Signals true/false when day night changes
func _on_day_night_timer_is_daytime(is_day: Variant) -> void:
	pass # Replace with function body.
	
	if is_day: # Kill enemies, show day popup
		$MobTimer.stop()
		print("day signal EMITTED")
		for e in get_tree().get_nodes_in_group("enemy"):
			e._burn()
	else: # Start spawning enemies
		pass
		$MobTimer.start()
