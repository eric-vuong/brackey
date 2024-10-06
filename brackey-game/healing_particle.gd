extends Sprite2D

@export var HealingParticle : PackedScene
var x_direction: float
var y_speed = 10
var x_speed = 10
const LIFETIME = 1.75
const FADE_START_TIME = 1
var age = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.y = 40
	position.x = randi_range(-27,27)
	$ChangeDirectionTimer.start(0.25)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	age = age + delta
	if age >= LIFETIME:
		queue_free()
		return
	position.y = position.y - delta*y_speed
	position.x = position.x + x_direction*x_speed*delta

	modulate.a = 1 - (age-FADE_START_TIME)/LIFETIME
	


func _on_change_direction_timer_timeout() -> void:
	x_direction = x_direction/5 + randfn(0,1)
