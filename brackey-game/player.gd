extends Area2D

@export var speed = 150
@export var bullet_scene = preload("res://bullet.tscn")
var can_shoot = true
var fire_rate = .4 # Seconds of downtime between shots
var autofire = false
var is_sprinting = false
var is_dodging = false
var sprint_bonus = 2
var screen_size
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
		print("dodge")
		#is_dodging = true
		pass
	if Input.is_action_pressed("dash"):
		print("dash")
		is_sprinting = true
	else:
		is_sprinting = false
		

	if velocity.length() > 0:
		if is_sprinting:
			velocity = velocity.normalized() * speed * sprint_bonus
		else:
			velocity = velocity.normalized() * speed
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

func shoot():
	if can_shoot:
		can_shoot = false
		var b = bullet_scene.instantiate()
		get_tree().root.add_child(b)
		b.start_direction(self.global_position, self.global_position.direction_to(get_global_mouse_position()))
		# Wait
		$BulletTimer.set_wait_time(fire_rate)
		$BulletTimer.start()


func _on_bullet_timer_timeout() -> void:
	can_shoot = true


func _on_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
	print("Player hit by enemy")
