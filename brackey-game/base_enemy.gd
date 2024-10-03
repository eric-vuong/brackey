extends Area2D
signal enemy_died()
@export var health = 100 # Max health. Increased over time
var current_hp = 1
@export var target: String# Player or core
var speed: int
var direction: Vector2
var burning = false
var drops = null
var droprate = 2 # as in 1 / droprate
var tier: int # 1 for weakest, 3 strongest
var points: int # tier, x2 if elite
var slowed = false
var slow_ratio = 0.5
var slow_duration = 1
var slow_duration_remaining: float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play()
	health += Global.hp_bonus
	$Hp.max_value = health
	$Hp.value = health
	speed += Global.spd_bonus
	current_hp = health
	var target_types = ["Player", "Core"]
	if target != "Player" and target != "Core":
		target = target_types[randi() % 2]
	#add_to_group("enemy")
	# Set random drop type if not defined
	if drops == null:
		drops = ["yellow", "red", "blue"][randi() % 3]
	points = tier
# Double size and stats of this enemy
func elite():
	self.scale = Vector2(2,2) #double in size
	if tier == 3:
		health = health * 8 # Base health of 6400, about 11s to kill at max power
		points = points * 2 # x4 points total
	else: # tier 1 and 2
		health = health * 8
	$Hp.max_value = health
	$Hp.value = health 
	current_hp = health
	droprate = 1
	points = points * 2
	speed = speed * 1.25 # Add 25% more speed
	#print(health, speed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#hit_animation()
		
	# Movement
	pathing(delta)
	
	# Damage recieved calculation
	#if check_if_hit():
		#print("we've been hit")
		#apply_hits()
		
	# Slow_duration_remaining
	if slowed:
		slow_duration_remaining = slow_duration_remaining - delta
		if slow_duration_remaining <= 0:
			slowed = false
			speed = speed / slow_ratio
		
	


#func check_if_hit():
	#return int(get_instance_id()) in Global.active_attacks.keys()

# Calculate damage received
#func apply_hits():
	#for attack_type in Global.active_attacks[get_instance_id()].keys():
			#for attacker_id in Global.active_attacks[get_instance_id()][attack_type].keys():
				#print("attack type: ", attack_type," attacker id: ", attacker_id, " attack value: ", Global.active_attacks[get_instance_id()][attack_type][attacker_id])
	#Global.active_attacks.erase(get_instance_id())

func hit_animation():
	return
	# example https://forum.godotengine.org/t/want-enemy-to-play-hurt-animation-when-hit/59639/3
	if $AnimatedSprite2D.animation == "hit" and $AnimatedSprite2D.is_playing():
		pass
	elif $AnimatedSprite2D.animation != "default":
		#print('playing default animation')
		$AnimatedSprite2D.play("default")

func _on_area_entered(area: Area2D) -> void:
	#print("enemy was hit", area)
	if area.is_in_group("player_bullet"):
		take_damage(Global.bullet_damage + Global.bullet_damage_boost)
		if Global.slowing_shot == true:
			slow_duration_remaining = slow_duration
			if not slowed:
				slowed = true
				speed = speed * slow_ratio
	#elif area.is_in_group("tower_bullet"):
	elif area.is_in_group("turret_bullet"):
		take_damage(Global.tower_bullet_dmg)
	elif area.is_in_group("turret_bullet2"):
		take_damage(Global.tower_bullet_dmg2)
	#$AnimatedSprite2D.play("hit")
	elif area.is_in_group("turret_ice"):
		take_damage(Global.ice_dmg)
		slow_duration_remaining = slow_duration
		if not slowed:
			slowed = true
			speed = speed * slow_ratio
	elif area.is_in_group("turret_ice2"):
		take_damage(Global.ice_dmg2)
		slow_duration_remaining = slow_duration
		if not slowed:
			slowed = true
			speed = speed * slow_ratio

# Move toward target position
func pathing(delta):
	if target == "Player":
		direction = self.global_position.direction_to(Global.player_pos)
	elif target == "Core":
		direction = self.global_position.direction_to(Global.core_pos)
	position += direction * speed * delta
	
# Reduce hp
func take_damage(dmg):
	current_hp -= dmg
	$Hp.value = current_hp
	if current_hp <= 0:
		Global.score += points
		# Spawn money
		if randi() % droprate == 0 and drops != null:
			# Tell main to load money at this position
			get_parent().spawn_money(drops, self.global_position)
		enemy_died.emit()
		queue_free()

func _burn():
	burning = true
	$BurnTimer.start()


func _on_burn_timer_timeout() -> void:
	take_damage(0.2 * health)
