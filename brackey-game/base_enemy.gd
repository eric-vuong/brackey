extends Area2D
signal enemy_died()
@export var health = 100
var current_hp = 1
@export var target: String# Player or core
var speed: int
var direction: Vector2
var burning = false
var drops = null
var droprate = 2 # as in 1 / droprate
var tier: int # 1 for weakest, 3 strongest
var points: int # tier, x2 if elite
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
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
		health *= 5
	else: # tier 1 and 2
		health *= 4
	$Hp.max_value = health
	$Hp.value = health 
	current_hp = health
	droprate = 1
	points *= 2
	speed += 10 # Add small speed bonus

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#hit_animation()
		
	# Movement
	pathing(delta)
	
	# Damage recieved calculation
	#if check_if_hit():
		#print("we've been hit")
		#apply_hits()
	


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
		take_damage(Global.bullet_damage)
	#elif area.is_in_group("tower_bullet"):
	else:
		#print("by tower")
		take_damage(Global.tower_bullet_dmg)
	#$AnimatedSprite2D.play("hit")

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
