extends Area2D
signal gameover
@export var bullet_scene = preload("res://bullet.tscn")
@export var max_hp = 40
var current_hp: int
var can_shoot = true
var autofire = false
var is_sprinting = false
var is_dodging = false
var sprint_bonus = 1.4
var screen_size
var is_hitable = true
var is_dead = false
var spread = 0.15 # radians or 8.6 deg
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	current_hp = max_hp
	$HpBar.max_value = max_hp
	$HpBar.value = current_hp
	global_position = Vector2(200,200)
	is_dead = false
	is_hitable = true

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
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	if velocity.x != 0:
		pass
		#$AnimatedSprite2D.animation = "walk"
		#$AnimatedSprite2D.flip_v = false
		# See the note below about boolean assignment.
		#$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		pass
		#$AnimatedSprite2D.animation = "up"
		#$AnimatedSprite2D.flip_v = velocity.y > 0
	# Take damage
	if is_hitable:
		var inside_player = get_overlapping_areas()
		if inside_player:
			# Apply damage. flat for now
			for enemy in inside_player:
				take_damage(10)
			is_hitable = false
			$DamageTimer.set_wait_time(1)
			$DamageTimer.start()

func shoot():
	if can_shoot:
		can_shoot = false
		# Wait
		$BulletTimer.set_wait_time(Global.fire_rate)
		$BulletTimer.start()
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

func create_bullet(offset):
	var b = bullet_scene.instantiate()
	get_tree().root.add_child(b)
	b.start_direction(self.global_position, self.global_position.direction_to(get_global_mouse_position()).rotated(offset))

func _on_bullet_timer_timeout() -> void:
	can_shoot = true


func _on_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
	print("Player hit by enemy")
	
func take_damage(dmg):
	current_hp -= (dmg * (100 - Global.player_defense) * 0.01)
	$HpBar.value = current_hp
	if current_hp <= 0:
		is_dead = true
		gameover.emit()
		


func _on_damage_timer_timeout() -> void:
	is_hitable = true
