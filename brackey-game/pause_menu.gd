extends Control
var parent = null
var can_resume = false 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") and can_resume:
		# UNPAUSE GAME
		resume()
	elif !can_resume and Input.is_action_just_released("pause"):
		can_resume = true
func resume():
	hide()
	parent.get_tree().paused = false
func pause():
	show()
	can_resume = false
	parent.get_tree().paused = true
func _on_resume_pressed() -> void:
	resume()
