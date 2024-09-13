extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CoreHp.max_value = Global.core_max_hp
	$CoreHp.value = Global.core_hp
	$Warning.hide()


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

func _on_core_hurt_timeout() -> void:
	$Warning.hide()
