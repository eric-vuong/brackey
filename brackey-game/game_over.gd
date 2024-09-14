extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MarginContainer/VBoxContainer/Button.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	owner.new_game()

func set_score():
	$MarginContainer/VBoxContainer/Points.set_text("Score: " + str(Global.score))
