extends Timer
signal is_daytime(is_day)
var DAY_DURATION = 25 #seconds
var NIGHT_DURATION = 35
var START_TIME = DAY_DURATION + NIGHT_DURATION
var current_time = START_TIME
var is_day = true
var cycle_count = 0 #number of days passed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Pass time info to global
	Global.day_duration = DAY_DURATION
	Global.night_duration = NIGHT_DURATION
	current_time = START_TIME
	cycle_count = 0
	is_day = true
	Global.is_day = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	current_time = current_time - wait_time
	Global.current_time = current_time
	print("Current time ", current_time)
	#at end of night reset to start of daytime
	if current_time <= 0:
		current_time = START_TIME
		is_day = not is_day
		is_daytime.emit(is_day)
		#Global.is_day = is_day # Set time in global
		print('is day ', is_day)
	#at end of daytime change to night
	elif int(current_time) == int(START_TIME - DAY_DURATION):
		is_day = not is_day
		is_daytime.emit(is_day)
		print('is day ', is_day)
	
	#increment the days passed count
	if int(current_time) == int(START_TIME):
		cycle_count = cycle_count + 1
		print('starting day/night cycle # ', cycle_count)
