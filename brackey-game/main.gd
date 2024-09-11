extends Node2D
var wind = preload("res://wind_enemy.tscn")
var demon = preload("res://demon.tscn")
var genie = preload("res://genie.tscn")
var witch = preload("res://witch.tscn")

var enemy_list = [wind, demon, genie, witch]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	$PauseMenu.parent = self
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		# PAUSE GAME
		$PauseMenu.pause()
	if Input.is_action_just_pressed("gameoverdebug"):
		$Core.take_damage(999)
		
# Stop mob spawning, day night, show score, stop player
func game_over():
	print("game over func")
	$MobTimer.stop() # Stop mob spawning
	$DayNightTimer.stop() # Stop time
	$Core/CollisionShape2D.disabled = true # Stop core from being hit
	$Core/CollisionShape2D.disabled = true # Stop player from being hit
	$GameOver.show()
# Reset day counter and timer, clear enemies, clear towers, reset core hp, reset player and position
func new_game():
	print("game starting")
	# Mob timer should start when it becomes night
	$DayNightTimer._ready() # Resets start time
	$DayNightTimer.start()
	$Core/CollisionShape2D.disabled = false # Enable hitboxes
	$Core/CollisionShape2D.disabled = false
	$GameOver.hide()
	# Kill all enemies
	for e in get_tree().get_nodes_in_group("enemy"):
		e.queue_free()
	# Reset player
	$Player._ready()
	# Reset core
	$Core._ready()
	$RainTileMap.hide()
	
# temp mob spawning func
func _on_mob_timer_timeout() -> void:
	if !Global.is_day:
		# Spawn random normal mob
		var mob = enemy_list[randi() % len(enemy_list)].instantiate()
		var mob_spawn_location = $MobPath/MobSpawnLocation
		mob_spawn_location.progress_ratio = randf()
		mob.position = mob_spawn_location.position
		add_child(mob)

# Signals true/false when day night changes
func _on_day_night_timer_is_daytime(is_day: Variant) -> void:
	pass # Replace with function body.
	
	if is_day: # Kill enemies, show day popup
		Global.is_day = true
		$MobTimer.stop()
		print("day signal EMITTED")
		for e in get_tree().get_nodes_in_group("enemy"):
			e._burn()
		$RainTileMap.hide()
	else: # Start spawning enemies
		Global.is_day = false
		$MobTimer.start()
		$RainTileMap.show()

# Triggered when player hits 0 hp
func _on_player_gameover() -> void:
	game_over()


func _on_core_gameover() -> void:
	$Player.is_dead = true
	game_over()
