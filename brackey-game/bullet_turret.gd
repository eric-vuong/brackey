extends Area2D

@export var bullet_scene = preload("res://bullet.tscn")

var can_shoot = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func shoot():
	if can_shoot:
		can_shoot = false
		# Wait
		$BulletTimer.set_wait_time(1)
		$BulletTimer.start()
		create_bullet(0)

func create_bullet(offset):
	var b = bullet_scene.instantiate()
	get_tree().root.add_child(b)
	b.start_direction(self.global_position, self.global_position.direction_to(get_global_mouse_position()).rotated(offset))
	



func _on_bullet_timer_timeout() -> void:
	can_shoot = true
