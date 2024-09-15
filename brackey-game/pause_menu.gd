extends CanvasLayer
var parent = null
var can_resume = false 
var sound = AudioServer.get_bus_index("Sound")
var music = AudioServer.get_bus_index("Music")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	_on_music_slider_value_changed(0.5)
	_on_volume_slider_value_changed(0.5)
	


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


func _on_new_game_pressed() -> void:
	resume()
	owner.new_game()


func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music, linear_to_db(value))


func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sound, linear_to_db(value))
