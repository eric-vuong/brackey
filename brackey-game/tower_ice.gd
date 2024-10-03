extends Area2D

var speed = 700
@export var TowerIce : PackedScene
var direction : Vector2
var lifetime = 0.3
var penetration: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	penetration = Global.ice_pierce #1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * speed * delta

func upgrade():
	penetration = Global.ice_pierce2 #2
	$AnimatedSprite2D.play("upgraded")
	add_to_group("turret_ice2")
	remove_from_group("turret_ice")
func play_default():
	$AnimatedSprite2D.play("default")
func start_direction(pos, dir):
	position = pos
	direction = dir
	$Timer.set_wait_time(lifetime)
	$Timer.start()
	self.rotate(dir.angle())
	


func _on_timer_timeout() -> void:
	queue_free()
	
func _on_area_entered(area: Area2D) -> void:
	if penetration < 1: # enemy can only be hit by same bullet once
		queue_free()
	else:
		penetration -= 1
