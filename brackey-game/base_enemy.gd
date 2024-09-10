extends Area2D

@export var health = 100
var current_hp = 1
@export var target: String = "Core"# Player or core
@export var speed: int = 30
var direction: Vector2
var burning = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Hp.max_value = health
	$Hp.value = health
	current_hp = health
	var target_types = ["Player", "Core"]
	target = target_types[randi() % 2]
	#add_to_group("enemy")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# example https://forum.godotengine.org/t/want-enemy-to-play-hurt-animation-when-hit/59639/3
	if $AnimatedSprite2D.animation == "hit" and $AnimatedSprite2D.is_playing():
		pass
	elif $AnimatedSprite2D.animation != "default":
		#print('playing default animation')
		$AnimatedSprite2D.play("default")
		
	# Movement
	pathing()
	position += direction * speed * delta
		
	
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
		

func _on_area_entered(area: Area2D) -> void:
	#print("enemy was hit")
	if area.is_in_group("player_bullet"):
		take_damage(Global.bullet_damage)
	$AnimatedSprite2D.play("hit")

# Move toward target position
func pathing():
	if target == "Player":
		direction = self.global_position.direction_to(Global.player_pos)
	elif target == "Core":
		direction = self.global_position.direction_to(Global.core_pos)
# Reduce hp
func take_damage(dmg):
	current_hp -= dmg
	$Hp.value = current_hp
	if current_hp <= 0:
		queue_free()

func _burn():
	burning = true
	$BurnTimer.start()


func _on_burn_timer_timeout() -> void:
	take_damage(health*.25)
