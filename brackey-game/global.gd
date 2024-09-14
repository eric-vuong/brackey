extends Node

#var active_attacks = {}

# Player values
var player_pos: Vector2
var player_move_speed: int
var player_defense: int
var can_shop: bool
# Core
var core_pos: Vector2
var core_max_hp = 1000
var core_hp: int
# Player Bullet
var bullet_damage: int
var pierce: int
var fire_rate: float
var multi_shot: int
# Turrets
var area_turret_dmg = 5
var tower_bullet_dmg = 100
var tower_pierce = 10
var active_tower = null # The tower player is near enough to activate

# Time
var is_day: bool = true
var day_duration: int
var night_duration: int
var current_time: int

# Scores
var score = 0
var yellow = 0
var red = 0
var blue = 0

# Modifiers
var bullet_size_mod = 1
var accuracy = 1
var run_and_gun = false
var reverse_shots = false
var life_time_mod = 1
var multi_bonus = 0
var bullet_damage_mod = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_move_speed = 100
	player_defense = 0
	bullet_damage = 10
	pierce = 0
	fire_rate = 0.75
	multi_shot = 1
	can_shop = false
	score = 0
	yellow = 1000
	red = 1000
	blue = 1000
	
	core_hp = core_max_hp


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func test():
	print("global test")
	
#func set_active_attack(attacker_id: int, target_id: int, attack_type, attack_value):
	#active_attacks[int(target_id)] = {str(attack_type):{attacker_id:attack_value}}
