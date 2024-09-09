extends Area2D

@export var speed = 100
var screen_size
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right") or Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down") or Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up") or Input.is_action_pressed("up"):
		velocity.y -= 1

	if velocity.length() > 0:
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
