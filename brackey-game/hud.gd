extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_count():
	$Yellow/YellowCount.set_text(str(Global.yellow))
	$Red/RedCount.set_text(str(Global.red))
	$Blue/BlueCount.set_text(str(Global.blue))
