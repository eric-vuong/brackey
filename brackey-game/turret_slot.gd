extends Area2D
var has_turret: bool # Can only place 1 turret here

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Disable turrets
	$AuraTurret/AnimatedSprite2D.play()
	
	toggle_aura(true)
	toggle_bullet(true)
	toggle_ice(true)
	has_turret = false
	$Controls.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func toggle_aura(turned_off):
	$AuraTurret/TurretAura.disabled = turned_off
	if turned_off:
		$AuraTurret.hide()
	else:
		$AuraTurret.show()
		$AuraTurret/TurretAura/AuraPulse.play()
		$Controls.hide()
func toggle_bullet(turned_off):
	$BulletTurret.disabled = turned_off
	if turned_off:
		$BulletTurret.hide()
	else:
		$BulletTurret.show()
		$BulletTurret/FireBall.play()
		$Controls.hide()
func toggle_ice(turned_off):
	$IceTurret.disabled = turned_off
	if turned_off:
		$IceTurret.hide()
	else:
		$IceTurret.show()
		#$BulletTurret/FireBall.play()
		$Controls.hide()
func set_turret(turret_type):
	if has_turret:
		return
	if turret_type == "bullet":
		toggle_bullet(false)
	elif turret_type == "aura":
		toggle_aura(false)
	elif turret_type == 'ice':
		toggle_ice(false)
	has_turret = true
func enable_slot(is_active):
	if !is_active:
		hide()
		$CollisionShape2D.disabled = true
	else:
		show()
		$CollisionShape2D.disabled = false

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		if !has_turret:
			$Controls.show()
		Global.active_tower = self


func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		$Controls.hide()
		Global.active_tower = null
