extends Area2D
var speed = 500
@export var Bullet : PackedScene
var direction : Vector2
var lifetime = 1
var penetration = 0
var is_returning = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	penetration = Global.pierce
	if Global.bullet_damage >= 20:
		$AnimatedSprite2D.play("upgraded")
	# Big shots
	self.scale = Vector2(Global.bullet_size_mod,Global.bullet_size_mod)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * speed * delta
	
func start_direction(pos, dir):
	position = pos
	direction = dir
	$Timer.set_wait_time(lifetime)
	$Timer.start()
	self.rotate(dir.angle())


func _on_timer_timeout() -> void:
	# remove bullet on timeout unless return shots is on
	if Global.return_shots == false:
		queue_free()
		return
	# Return shots is on but bullet is already returning, so remove it
	if is_returning == true:
		queue_free()
		return
	# Set bullet to return direction
	# Reverse direction, toggle collision to allow double hits
	$Timer.start()
	direction = direction.rotated(PI)
	$CollisionShape2D.disabled = true
	$CollisionShape2D.disabled = false
	is_returning = true
func _on_area_entered(area: Area2D) -> void:
	#print("bullet hit enemy")
	# Global.set_active_attack(get_instance_id(), area.get_instance_id(),'damage', 1)
	#Global.test()
	if penetration < 1: # enemy can only be hit by same bullet once
		queue_free()
	else:
		penetration -= 1
