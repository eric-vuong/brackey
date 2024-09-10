extends Node

#var active_attacks = {}

# Player values
var player_pos: Vector2

# Core
var core_pos: Vector2

# Player Bullet
var bullet_damage: int = 10
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func test():
	print("global test")
	
#func set_active_attack(attacker_id: int, target_id: int, attack_type, attack_value):
	#active_attacks[int(target_id)] = {str(attack_type):{attacker_id:attack_value}}
