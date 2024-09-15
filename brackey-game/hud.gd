extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CoreHp.max_value = Global.core_max_hp
	$CoreHp.value = Global.core_hp
	$Time.set_text("Night in: " + str(Global.day_duration))
	$Warning.hide()
	$Date.set_text("Day " + str(Global.cycle_count + 1))
	$Victory.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_count():
	$Yellow/YellowCount.set_text(str(Global.yellow))
	$Red/RedCount.set_text(str(Global.red))
	$Blue/BlueCount.set_text(str(Global.blue))
func update_core():
	$CoreHp.value = Global.core_hp
	$CoreHurt.start(2)
	$Warning.show()
func update_time():
	if Global.is_day:
		if Global.current_time != 0:
			$Time.set_text("Night in: " + str(Global.current_time - Global.night_duration))
		else:
			$Time.set_text("Night in: " + str(Global.day_duration))
	else:
		$Time.set_text("Dawn in: " + str(Global.current_time))
	$Date.set_text("Day " + str(Global.cycle_count + 1))
func _on_core_hurt_timeout() -> void:
	$Warning.hide()
func show_win():
	$Victory.show()
	$VictoryTimer.start()

func _on_victory_timer_timeout() -> void:
	$Victory.hide()
