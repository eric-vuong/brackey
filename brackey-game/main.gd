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
var mushroom = preload("res://mushroom.tscn")
var charge_enemy = preload("res://charge_enemy.tscn")
var air = preload("res://air.tscn")
var goblin = preload("res://goblin.tscn")


var easy = [skeleton, mushroom, wind, goblin]
var med = [demon, genie, witch, skeleton, mushroom, wind, air, goblin]
var hard = [demon, genie, witch, skeleton, mushroom, charge_enemy, wind, air, goblin]
var enemy_list

#var spawn_time = 2

var turret_list # Omit default turret

const NIGHT_FADE_IN_ADDITIONS = [9,8,7,6,5,4,3,2,1,0]
const NIGHT_FADE_IN_ALPHA = [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1]
const NIGHT_FADE_OUT_ADDITIONS = [9,8,7,6,5,4,3,2,1,0]
const NIGHT_FADE_OUT_ALPHA = [1,0.9,0.8,0.7,0.6,0.5,0.4,0.3,0.2,0.1]


#var enemy_list = [charge_enemy]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PauseMenu.parent = self
	# Connect core hurt signal
	$Core.connect("core_hurt", _core_hurt)
	turret_list = [$TurretSlot2, $TurretSlot3, $TurretSlot4, $TurretSlot5,$TurretSlot6,$TurretSlot7]
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
	if Input.is_action_just_pressed("set_ice_turret") and Global.active_tower != null:
		Global.active_tower.set_turret("ice")
		
	# Skip to night
	if Input.is_action_just_pressed("time"):
		if Global.is_day and Global.current_time - 3 > Global.night_duration:
			$DayNightTimer.current_time = Global.night_duration + 2
			$DayMusic.stop()
	# DEBUG
	if Input.is_action_just_pressed("gameoverdebug"):
		
		pass
		#$Core.take_damage(999)

	
		
# Stop mob spawning, day night, show score, stop player
func game_over():
	print("GAME OVER")
	$GameOverSound.play()
	$DayMusic.stop()
	$NightMusic.stop()
	$MobTimer.stop() # Stop mob spawning
	$DayNightTimer.stop() # Stop time
	$Core/CollisionShape2D.disabled = true # Stop core from being hit
	$Core/CollisionShape2D.disabled = true # Stop player from being hit
	$GameOver.set_score()
	$GameOver/MarginContainer/VBoxContainer/Button.show()
	Global.active_tower = null
	for t in get_tree().get_nodes_in_group("turret_slot"):
		t._ready()
# Reset day counter and timer, clear enemies, clear towers, reset core hp, reset player and position
func new_game():
	print("Game Starting")
	$DayMusic.stop()
	$DayMusic.play()
	$NightMusic.stop()
	$Rain.stop()
	$MobTimer.set_wait_time(1.5)
	enemy_list = easy
	# Mob timer should start when it becomes night
	$DayNightTimer._ready() # Resets start time
	$DayNightTimer.start()
	$GameOver/MarginContainer/VBoxContainer/Button.hide()
	# Kill all enemies
	for e in get_tree().get_nodes_in_group("enemy"):
		#Disable drops
		e.drops == null
		e.take_damage(e.health * 100)
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
	#print("free money", get_tree().get_nodes_in_group("items"))
	
	for i in get_tree().get_nodes_in_group("items"):
		i.queue_free()
		#call_deferred("queue_free", i)
	update_money()
	$HUD._ready()
	Global.active_tower = null
	for t in get_tree().get_nodes_in_group("turret_slot"):
		t._ready()
	_update_score()
	disable_turrets()
	$RestartTimer.start()

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
	#add_child(c)

func update_money():
	$HUD.update_count()
func money_sound():
	$Money.play()
# temp mob spawning func
func _on_mob_timer_timeout() -> void:
	if !Global.is_day and Global.current_time > 5:
		#print("Global time mob", Global.current_time)
		# Spawn random normal mob
		var mob = enemy_list[randi() % len(enemy_list)].instantiate()

		var mob_spawn_location = $MobPath/MobSpawnLocation
		mob_spawn_location.progress_ratio = randf()
		mob.position = mob_spawn_location.position
		mob.connect("enemy_died", _update_score)
		add_child(mob)
		# ex tier 1 elites spawn on cycle 3 (day 4)
		#print("t",mob.tier,"c", Global.cycle_count, mob.health)
		if mob.tier == 1 and Global.cycle_count >= 3:
			if randi() % 100 < Global.elite_chance:
				mob.elite()
		elif mob.tier == 2 and Global.cycle_count >= 4:
			if randi() % 100 < Global.elite_chance:
				mob.elite()
		elif mob.tier == 3 and Global.cycle_count >= 6:
			if randi() % 100 < Global.elite_chance:
				mob.elite()
func spawn_boss(is_elite):
	var boss = charge_enemy.instantiate()
	if is_elite:
		boss.elite()
	var boss_spawn_location = $MobPath/MobSpawnLocation
	boss_spawn_location.progress_ratio = randf()
	boss.position = boss_spawn_location.position
	boss.connect("enemy_died", _update_score)
	add_child(boss)
# Signals true/false when day night changes
func _on_day_night_timer_is_daytime(is_day: Variant) -> void:
	if is_day: # Kill enemies, show day popup
		Global.is_day = true
		$DayMusic.play()
		$MobTimer.stop()
		# Cycle 0 at end of day 1 (so first night finished is first time this signals)
		print("Daytime signaled", Global.cycle_count)
		for e in get_tree().get_nodes_in_group("enemy"):
			e._burn()
		$RainTileMap.hide()
		$PlayerBody/PlayerArea/Camera2D/NightEffect.hide()
		# Spawn new turret
		enable_turret(Global.cycle_count)
		# Make enemies harder
		if Global.cycle_count == 0:
			print("Medium enemies")
			enemy_list = med
		elif Global.cycle_count == 2:
			print("Hard enemies")
			enemy_list = hard
		# Increase spawn rate
		var spawn_delay = $MobTimer.get_wait_time() * 0.9
		if spawn_delay >= 0.3:
			$MobTimer.set_wait_time(spawn_delay)
		else:
			$MobTimer.set_wait_time(1)
		print("Mob spawn delay", $MobTimer.get_wait_time())
		# They get faster over time
		if Global.cycle_count >= 3:
			if Global.spd_bonus < 20:
				Global.spd_bonus += 1
			if Global.elite_chance == 0:
				Global.elite_chance = 25
			elif Global.elite_chance < 50:
				Global.elite_chance += 5
		#print("cycle", Global.cycle_count)
		if Global.cycle_count == 6: # ended day 7
			$HUD.show_win()
	else: # Start spawning enemies
		#$Rain.play()
		$NightMusic.play()
		Global.is_day = false
		$MobTimer.start()
		$RainTileMap.show()
		
		# Delete all uncollected items
		for i in get_tree().get_nodes_in_group("items"):
			i.queue_free()
		# Spawn the boss on specific days. could add special FX or delay
		if Global.cycle_count == 2:
			spawn_boss(false)
		if Global.cycle_count == 5:
			spawn_boss(true)
# Disable all turrets except turret 1.
# Called on start of game
# Each day 1 new turret slot will reveal
func disable_turrets():
	$TurretSlot2.enable_slot(false)
	$TurretSlot3.enable_slot(false)
	$TurretSlot4.enable_slot(false)
	$TurretSlot5.enable_slot(false)
	$TurretSlot6.enable_slot(false)
	$TurretSlot7.enable_slot(false)
func enable_turret(cycle):
	if cycle < len(turret_list):
		turret_list[cycle].enable_slot(true)
# Triggered when player hits 0 hp
func _on_player_body_gameover() -> void:
	game_over()
	


func _on_core_gameover() -> void:
	$PlayerBody.is_dead = true
	game_over()

func _core_hurt():
	$HUD.update_core()
func _update_score():
	$GameOver.set_score()


func _on_day_night_timer_time_changed() -> void:
	# Update time display
	$HUD.update_time()
	
	if Global.is_day and $PlayerBody.current_hp < $PlayerBody.max_hp:
		$HealthPotion.play("jumping")
	else:
		$HealthPotion.play("idle")
	
	# Play rain 1s before visual
	if Global.current_time == Global.night_duration + 1:
		$Rain.play()
	
	#fade in night
	if Global.current_time >= Global.night_duration and Global.current_time <= Global.night_duration + NIGHT_FADE_IN_ADDITIONS.max():
		$PlayerBody/PlayerArea/Camera2D/NightEffect.show()
		for i in range(NIGHT_FADE_IN_ADDITIONS.size()):
			if Global.current_time == Global.night_duration + NIGHT_FADE_IN_ADDITIONS[i]:
				$PlayerBody/PlayerArea/Camera2D/NightEffect.modulate = Color(255,255,255,NIGHT_FADE_IN_ALPHA[i])
				return
				
	#fade out night
	if Global.current_time >= 0 and Global.current_time <= 0 + NIGHT_FADE_OUT_ADDITIONS.max():
		for i in range(NIGHT_FADE_OUT_ADDITIONS.size()):
			if Global.current_time == 0 + NIGHT_FADE_OUT_ADDITIONS[i]:
				$PlayerBody/PlayerArea/Camera2D/NightEffect.modulate = Color(255,255,255,NIGHT_FADE_OUT_ALPHA[i])
				return


	#fade out_night

	# HEAL PLAYER ON DAY START
	#if Global.is_day and !$PlayerBody.is_dead:
	#	$PlayerBody.take_damage(-999)


func _on_restart_timer_timeout() -> void:
	#print("timer restart")
	for i in get_tree().get_nodes_in_group("items"):
		i.queue_free()
	# Kill all enemies
	for e in get_tree().get_nodes_in_group("enemy"):
		#Disable drops
		e.drops == null
		e.take_damage(e.health * 100)
