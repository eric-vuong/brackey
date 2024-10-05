extends Area2D
var has_turret: bool # Can only place 1 turret here
var active_turret: String
var is_upgraded = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Disable turrets
	
	toggle_aura(true)
	toggle_bullet(true)
	toggle_ice(true)
	has_turret = false
	$Controls.hide()
	$Upgrade.hide()
	$Red.hide()
	$Yellow.hide()
	$Blue.hide()
	is_upgraded = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func toggle_aura(turned_off):
	$AuraTurret/TurretAura.disabled = turned_off
	if turned_off:
		$AuraTurret.hide()
	else:
		active_turret = "aura"
		$AuraTurret/TurretAura.degrade()
		$AuraTurret/PulseTimer.set_wait_time(1)
		$AuraTurret/AnimatedSprite2D.play("default")
		$AuraTurret.show()
		$AuraTurret/TurretAura/AuraPulse.play()
		$Controls.hide()
func toggle_bullet(turned_off):
	$BulletTurret.disabled = turned_off
	if turned_off:
		$BulletTurret.hide()
	else:
		active_turret = "bullet"
		$BulletTurret.degrade()
		$BulletTurret.show()
		$BulletTurret/FireBall.play()
		$Controls.hide()
func toggle_ice(turned_off):
	$IceTurret.disabled = turned_off
	if turned_off:
		$IceTurret.hide()
	else:
		active_turret = "ice"
		$IceTurret.degrade()
		$IceTurret/IceShard.play()
		$IceTurret.show()
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

func upgrade():
	# Check money
	if is_upgraded:
		return
	if active_turret == "bullet":
		if Global.red >= 10:
			Global.red -= 10
			$Money.play()
			$BulletTurret.upgrade()
			is_upgraded = true
			hide_upgrades()
	if active_turret == "aura":
		if Global.yellow >= 10:
			Global.yellow -= 10
			$Money.play()
			$AuraTurret/TurretAura.upgrade()
			$AuraTurret/AnimatedSprite2D.play("upgraded")
			$AuraTurret/PulseTimer.set_wait_time(0.75)
			is_upgraded = true
			hide_upgrades()
	if active_turret == "ice":
		if Global.blue >= 10:
			Global.blue -= 10
			$Money.play()
			$IceTurret.upgrade()
			is_upgraded = true
			hide_upgrades()
	get_tree().current_scene.update_money()
	

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		if !has_turret:
			$Controls.show()
		elif !is_upgraded:
			$Upgrade.show()
			if active_turret == "bullet":
				$Red.show()
			if active_turret == "aura":
				$Yellow.show()
			if active_turret == "ice":
				$Blue.show()
		Global.active_tower = self

func hide_upgrades():
	$Upgrade.hide()
	$Red.hide()
	$Yellow.hide()
	$Blue.hide()
func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		$Controls.hide()
		Global.active_tower = null
		$Upgrade.hide()
		$Red.hide()
		$Yellow.hide()
		$Blue.hide()
