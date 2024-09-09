extends Area2D
var speed = 200
@export var Bullet : PackedScene
var direction : Vector2
var lifetime = 2
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
