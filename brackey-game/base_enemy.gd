extends Area2D

@export var health = 100 
@export var target: String = "Core"# Player or core
@export var speed: int = 30
var direction: Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	# example https://forum.godotengine.org/t/want-enemy-to-play-hurt-animation-when-hit/59639/3
	if $AnimatedSprite2D.animation == "hit" and $AnimatedSprite2D.is_playing():
		pass
	elif $AnimatedSprite2D.animation != "default":
		print('playing default animation')
		$AnimatedSprite2D.play("default")
		
	# Movement
	pathing()
	position += direction * speed * delta
		


func _on_area_entered(area: Area2D) -> void:
	print("enemy was hit")
	$AnimatedSprite2D.play("hit")

# Move toward target position
func pathing():
	if target == "Player":
		direction = self.global_position.direction_to(Global.player_pos)
	elif target == "Core":
		direction = self.global_position.direction_to(Global.core_pos)
