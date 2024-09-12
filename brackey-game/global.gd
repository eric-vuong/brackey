extends Node

#var active_attacks = {}

# Player values
var player_pos: Vector2
var player_move_speed: int
var player_defense: int
# Core
var core_pos: Vector2

# Player Bullet
var bullet_damage: int
var pierce: int
var fire_rate: float
var multi_shot: int

# Time
var is_day: bool = true
var day_duration: int
var night_duration: int
var current_time: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_move_speed = 150
	player_defense = 0
	bullet_damage = 10
	pierce = 0
	fire_rate = 0.75
	multi_shot = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func test():
	print("global test")
	
#func set_active_attack(attacker_id: int, target_id: int, attack_type, attack_value):
	#active_attacks[int(target_id)] = {str(attack_type):{attacker_id:attack_value}}
