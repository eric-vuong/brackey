extends Area2D
var speed = 700
@export var TowerBullet : PackedScene
var direction : Vector2
var lifetime = 0.3
var penetration = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	penetration = Global.tower_pierce
	#if Global.bullet_damage > 16:
	
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * speed * delta
func play_default():
	$AnimatedSprite2D.play("default")
func upgrade():
	$AnimatedSprite2D.play("upgraded")
	penetration = Global.tower_pierce2
	add_to_group("turret_bullet2")
	remove_from_group("turret_bullet")
	
func start_direction(pos, dir):
	position = pos
	direction = dir
	$Timer.set_wait_time(lifetime)
	$Timer.start()
	self.rotate(dir.angle())


func _on_timer_timeout() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	#print("bullet hit enemy")
	# Global.set_active_attack(get_instance_id(), area.get_instance_id(),'damage', 1)
	#Global.test()
	if penetration < 1: # enemy can only be hit by same bullet once
		queue_free()
	else:
		penetration -= 1
