extends Area2D
var has_turret: bool # Can only place 1 turret here

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Disable turrets
	$AuraTurret/AnimatedSprite2D.play()
	
	toggle_aura(true)
	toggle_bullet(true)
	has_turret = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func toggle_aura(turned_off):
	$AuraTurret/TurretAura.disabled = turned_off
	if turned_off:
		$AuraTurret.hide()
	else:
		$AuraTurret.show()
func toggle_bullet(turned_off):
	$BulletTurret.disabled = turned_off
	if turned_off:
		$BulletTurret.hide()
	else:
		$BulletTurret.show()
func set_turret(turret_type):
	if has_turret:
		return
	if turret_type == "bullet":
		toggle_bullet(false)
	elif turret_type == "aura":
		toggle_aura(false)
	has_turret = true

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		Global.active_tower = self


func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		Global.active_tower = null
