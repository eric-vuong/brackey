extends Area2D

@export var ice_scene = preload("res://tower_ice.tscn")
var disabled = false
var can_shoot = true
var shoot_cooldown = 1
var spread = 0.30

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_shoot and !disabled:
		shoot()


func shoot():
	can_shoot = false
	# Wait
	$BulletTimer.set_wait_time(shoot_cooldown)
	$BulletTimer.start()
	
	
	var enemy_position = aim()
	# Multishot
	var shots = 3
	if enemy_position:
		create_bullet(enemy_position,0) #straight
		shots = (shots - 1) * 0.5
		while shots > 0:
			create_bullet(enemy_position,spread*shots)
			create_bullet(enemy_position,-spread*shots)
			shots -= 1
	
	
func aim():
	var in_range = get_overlapping_areas()
	
	var nearest_d_ind = -1
	var nearest_d_squared: float = -1
	if in_range:
		for i in range (in_range.size()):
			#print(i)
			if in_range[i].is_in_group("enemy"):
				var d_squared = self.global_position.distance_squared_to(in_range[i].global_position)
				if nearest_d_squared == -1 or d_squared <= nearest_d_squared:
					nearest_d_squared = d_squared
					nearest_d_ind = i
		
	if nearest_d_ind == -1:
		return false
	else:
		return in_range[nearest_d_ind].global_position
		
		
func create_bullet(enemy_position,offset):
	var b = ice_scene.instantiate()
	get_tree().root.add_child(b)
	b.start_direction(self.global_position, self.global_position.direction_to(enemy_position).rotated(offset))
	# $FireBall.play()
	

func _on_bullet_timer_timeout() -> void:
	can_shoot = true
