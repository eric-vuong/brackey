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
var area_turret_dmg = 8
var area_turret_dmg2 = 20
var tower_bullet_dmg = 80
var tower_bullet_dmg2 = 200
var tower_pierce = 1
var tower_pierce2 = 2
var ice_dmg = 10
var ice_dmg2 = 15
var ice_pierce = 1
var ice_pierce2 = 2
var active_tower = null # The tower player is near enough to activate

# Time
var is_day: bool = true
var day_duration: int
var night_duration: int
var current_time: int
var cycle_count: int

# Scores
var score = 0
var yellow: int
var red: int
var blue: int

# Difficulty
var elite_chance: int
var hp_bonus: int
var spd_bonus: int

# Modifiers - not used
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
	yellow = 0
	red = 0
	blue = 0
	
	core_hp = core_max_hp

	elite_chance = 0
	spd_bonus = 0
	hp_bonus = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func test():
	print("global test")
	
#func set_active_attack(attacker_id: int, target_id: int, attack_type, attack_value):
	#active_attacks[int(target_id)] = {str(attack_type):{attacker_id:attack_value}}
