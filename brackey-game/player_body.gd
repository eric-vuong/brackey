extends CharacterBody2D
signal gameover
@export var bullet_scene = preload("res://bullet.tscn")
@export var max_hp = 40
var current_hp: int
var can_shoot = true
var autofire = false
var is_sprinting = false
var is_dodging = false
var sprint_bonus = 1.5
var screen_size
var is_hitable = true
var is_dead = false
var spread = 0.30 # 0.15 radians or 8.6 deg
var is_healing
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	current_hp = max_hp
	$PlayerArea/HpBar.max_value = max_hp
	$PlayerArea/HpBar.value = current_hp
	global_position = Vector2(200,200)
	is_dead = false
	is_hitable = true
	is_healing = false
	$PlayerArea/AnimatedSprite2D.animation = "default"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_dead: # Stop processing if not alive
		return
	# Update player location for global
	Global.player_pos = self.global_position
	var velocity = Vector2.ZERO # The player's movement vector.
	
	if Input.is_action_pressed("shoot") or autofire:
		if !is_sprinting and !is_dodging:
			shoot()
	if Input.is_action_just_pressed("autofire"):
		autofire = !autofire

	if !is_dodging: # Can only choose movement when not in a dodge
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
	if Input.is_action_just_pressed("dodge"):
		#print("dodge")
		#is_dodging = true
		pass
	if Input.is_action_pressed("dash"):
		is_sprinting = true
	else:
		is_sprinting = false
	
		

	if velocity.length() > 0:
		if is_sprinting:
			velocity = velocity.normalized() * Global.player_move_speed * sprint_bonus
		else:
			velocity = velocity.normalized() * Global.player_move_speed
	position += velocity * delta

	if velocity.x != 0:
		$PlayerArea/AnimatedSprite2D.animation = "right"
		if velocity.x < 0: # Move left
			$PlayerArea/AnimatedSprite2D.flip_h = true
		else:
			$PlayerArea/AnimatedSprite2D.flip_h = false
	else:
		# moving straight up or down
		if velocity.y > 0: # Move down
		#pass
			$PlayerArea/AnimatedSprite2D.animation = "default"
		elif velocity.y < 0:
			$PlayerArea/AnimatedSprite2D.animation = "back"
	# Take damage
	if is_hitable:
		var inside_player = $PlayerArea.get_overlapping_areas()
		if inside_player:
			# Apply damage once
			for enemy in inside_player:
				take_damage(10)
				break
			is_hitable = false
			$PlayerArea/DamageTimer.set_wait_time(1)
			$PlayerArea/DamageTimer.start()
	
	#physics collisions
	move_and_slide()
	if Global.is_day and !is_dead and Global.can_shop:
		$PlayerArea/HealTimer.set_paused(false)
	else:
		$PlayerArea/HealTimer.set_paused(true)

func shoot():
	if can_shoot:
		can_shoot = false
		# Wait
		$PlayerArea/BulletTimer.set_wait_time(Global.fire_rate)
		$PlayerArea/BulletTimer.start()
		# Fire odd number of bullets
		var shots = Global.multi_shot
		if shots % 2 == 1: # odd
			create_bullet(0) # fire straight
			shots = (shots - 1) * 0.5
			while shots > 0:
				create_bullet(spread*shots)
				create_bullet(-spread*shots)
				shots -= 1
		else: # even bullets
			shots = shots * 0.5
			while shots > 0:
				create_bullet(spread*shots - spread*0.5)
				create_bullet(-spread*shots + spread*0.5)
				shots -= 1
		# Play sound
		$PlayerArea/BulletSound.play()
		

func create_bullet(offset):
	var b = bullet_scene.instantiate()
	get_tree().root.add_child(b)
	b.start_direction(self.global_position, self.global_position.direction_to(get_global_mouse_position()).rotated(offset))

func _on_bullet_timer_timeout() -> void:
	can_shoot = true


#func _on_area_entered(area: Area2D) -> void:
	#pass # Replace with function body.
	#print("Player hit by enemy")
	
func take_damage(dmg):
	if dmg < 0:
		current_hp -= dmg # heal
	else:
		current_hp -= (dmg * (100 - Global.player_defense) * 0.01)
	$PlayerArea/HpBar.value = current_hp
	if current_hp <= 0:
		is_dead = true
		gameover.emit()
	elif current_hp > max_hp:
		current_hp = max_hp
		


func _on_damage_timer_timeout() -> void:
	is_hitable = true


func _on_player_area_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
	print("Player hit by enemy")


func _on_heal_timer_timeout() -> void:
	take_damage(-1)
