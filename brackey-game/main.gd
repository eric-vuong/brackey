extends Node2D

# Currency
var yellow = preload("res://yellow.tscn")
var red = preload("res://red.tscn")
var blue = preload("res://blue.tscn")

var wind = preload("res://wind_enemy.tscn")
var demon = preload("res://demon.tscn")
var genie = preload("res://genie.tscn")
var witch = preload("res://witch.tscn")
var skeleton = preload("res://skeleton.tscn")
var charge_enemy = preload("res://charge_enemy.tscn")

var enemy_list = [wind, demon, genie, witch, skeleton, charge_enemy]
#var enemy_list = [charge_enemy]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	$PauseMenu.parent = self
	# Connect core hurt signal
	$Core.connect("core_hurt", _core_hurt)
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if shop_visible():
			close_shop()
		else:
			# PAUSE GAME
			$PauseMenu.pause()
	if Input.is_action_just_pressed("interact"):
		if Global.can_shop and !shop_visible():
			open_shop()
		elif shop_visible(): # Hitting key twice closes shop if open
			close_shop()
		# Handle turret placement
		elif Global.active_tower != null: # and E was pressed
			Global.active_tower.set_turret("aura") # Set tower to aura
	if Input.is_action_just_pressed("q") and Global.active_tower != null:
		Global.active_tower.set_turret("bullet")# Set to bullet tower
	# Skip to night
	if Input.is_action_just_pressed("time"):
		if Global.is_day and Global.current_time - 3 > Global.night_duration:
			$DayNightTimer.current_time = Global.night_duration + 2
	# DEBUG
	if Input.is_action_just_pressed("gameoverdebug"):
		$Core.take_damage(999)
	
		
# Stop mob spawning, day night, show score, stop player
func game_over():
	print("game over func")
	$MobTimer.stop() # Stop mob spawning
	$DayNightTimer.stop() # Stop time
	$Core/CollisionShape2D.disabled = true # Stop core from being hit
	$Core/CollisionShape2D.disabled = true # Stop player from being hit
	$GameOver.set_score()
	$GameOver.show()
	Global.active_tower = null
	for t in get_tree().get_nodes_in_group("turret_slot"):
		t._ready()
# Reset day counter and timer, clear enemies, clear towers, reset core hp, reset player and position
func new_game():
	print("game starting")
	# Mob timer should start when it becomes night
	$DayNightTimer._ready() # Resets start time
	$DayNightTimer.start()
	$GameOver.hide()
	# Kill all enemies
	for e in get_tree().get_nodes_in_group("enemy"):
		e.queue_free()
	$Core/CollisionShape2D.disabled = false # Enable hitboxes
	$Core/CollisionShape2D.disabled = false
	# Reset global
	Global._ready()
	# Reset player
	$PlayerBody._ready()
	# Reset core
	$Core._ready()
	$RainTileMap.hide()
	$PlayerBody/PlayerArea/Camera2D/NightEffect.hide()
	# Reset shop
	for s in get_tree().get_nodes_in_group("shop_items"):
		#print(s)
		s._ready()
	# Handle money stuff
	for i in get_tree().get_nodes_in_group("items"):
		i.queue_free()
	update_money()
	$HUD._ready()
	Global.active_tower = null
	for t in get_tree().get_nodes_in_group("turret_slot"):
		t._ready()

func open_shop():
	$Shop.show()
func close_shop():
	$Shop.hide()
func shop_visible():
	return $Shop.visible
	
func spawn_money(currency, pos):
	var c
	if currency == "yellow":
		c = yellow.instantiate()
	if currency == "red":
		c = red.instantiate()
	if currency == "blue":
		c = blue.instantiate()
	c.global_position = pos
	call_deferred("add_child", c)
	#add_child(c)

func update_money():
	$HUD.update_count()
	
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
		$PlayerBody/PlayerArea/Camera2D/NightEffect.hide()
	else: # Start spawning enemies
		Global.is_day = false
		$MobTimer.start()
		$RainTileMap.show()
		$PlayerBody/PlayerArea/Camera2D/NightEffect.show()
# Triggered when player hits 0 hp
func _on_player_body_gameover() -> void:
	game_over()
	


func _on_core_gameover() -> void:
	$PlayerBody.is_dead = true
	game_over()

func _core_hurt():
	$HUD.update_core()


func _on_day_night_timer_time_changed() -> void:
	# Update time display
	$HUD.update_time()
