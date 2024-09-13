extends Button

var modifiers = [
	"Big Shots", # Bigger projectiles but slower bullet speed
	"Run and Gun", # Fire while sprinting but shots are inaccurate
	"Stay Still", # x2 fire rate while not moving, reduced firerate otherwise
	"Reverse Shots", # Fire from cursor to player, lifetime doubled
	"Bullet Hell", # Add 10 to multi shot, enemy speed increased
	"Close Range", # Bullet lifetime halved and damage doubled
]
var mod_list
var mod # The current mod offered in shop
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_modifiers()
	mod_list = modifiers.duplicate(true)
	mod_list.shuffle()
	print(mod_list)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Reset global modifiers
func reset_modifiers():
	Global.bullet_size_mod = 1
	Global.accuracy = 1 # Changes spread
	Global.run_and_gun = false
	Global.reverse_shots = false
	Global.life_time_mod = 1
	Global.multi_bonus = 0
	Global.bullet_damage_mod = 1
	$Desc.set_text("Power comes at a cost")

# Run whenever day time is signaled
func refresh():
	if len(mod_list) == 0:
		mod_list = modifiers.duplicate(true)
		mod_list.shuffle()
	#mod = mod_list.pop()
