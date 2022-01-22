extends AudioStreamPlayer

var start_db
var start_pitch

func _ready():
	start_db = volume_db
	start_pitch = pitch_scale 
	
	fade_db_start = volume_db

func play_usual():
	stop()
	fade_timer = -1
	
	volume_db = start_db
	pitch_scale = start_pitch
	
	play()

func play_sfx():
	stop()
	fade_timer = -1
	
	volume_db = start_db + rand_range(-0.05, 0.05)
	pitch_scale = start_pitch * rand_range(0.93, 1.07)
	
	print("Playing ", name ," at ", volume_db)
	play()

func fade(time: float):
	fade_timer = time
	fade_timer_max = time
	fade_db_start = volume_db
	
var fade_timer = -1
var fade_timer_max = -1
var fade_db_start
	
func _process(delta):
	if fade_timer >= 0:
		fade_timer -= delta
		var amount = fade_timer / fade_timer_max
		
		volume_db = linear2db(amount) + (fade_db_start - linear2db(1))
		
		if fade_timer < 0:
			stop()
			volume_db = start_db
