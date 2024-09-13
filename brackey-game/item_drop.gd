extends Area2D


# Called when the node enters the scene tree for the first time.
var currency_type: String # yellow, red, blue
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Player walked over
func _on_area_entered(area: Area2D) -> void:
	if currency_type == "yellow":
		Global.yellow += 1
	elif currency_type == "red":
		Global.red += 1
	elif currency_type == "blue":
		Global.blue += 1
	get_parent().update_money()
	queue_free()
