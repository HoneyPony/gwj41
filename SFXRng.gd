extends AudioStreamPlayer3D

var start_db
var start_pitch

func _ready():
	start_db = unit_db
	start_pitch = pitch_scale 

func play_usual():
	#fade_timer = -1
	play()

func play_sfx():
	#fade_timer = -1
	
	unit_db = start_db + rand_range(-0.05, 0.05)
	pitch_scale = start_pitch * rand_range(0.93, 1.07)
	
	play()
