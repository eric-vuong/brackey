extends Area2D
var speed = 300
@export var Bullet : PackedScene
var direction : Vector2
var lifetime = 2
var penetration = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * speed * delta
	
func start_direction(pos, dir):
	position = pos
	direction = dir
	$Timer.set_wait_time(lifetime)
	$Timer.start()


func _on_timer_timeout() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	print("bullet hit enemy")
	Global.set_active_attack(get_instance_id(), area.get_instance_id(),'damage', 1)
	Global.test()
	if penetration < 1:
		queue_free()
	else:
		penetration -= 1
