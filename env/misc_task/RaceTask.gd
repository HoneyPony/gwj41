extends Spatial

var is_racing = false

onready var checks = [
	$C0,
	$C1,
	$C2,
	$C3,
	$C4,
	$C5,
	$C6,
	$C7,
]

var race_timer = 0.0
var lap_num = 1

onready var lap = $Control/Lap
onready var time = $Control/Time

onready var race_clam = get_node("../RaceClam")

export(NodePath) onready var sprocket = GS.nodefp(self, sprocket)
onready var sprocket2 = $Sprocket2

var current_check = 0

func update_timer():
	var ipart = int(race_timer)
	var fpart = race_timer - ipart
	
	var seconds = String(ipart % 60)
	var minutes = String((ipart / 60) % 60)
	var hours = String(ipart / 3600)
	
	if seconds.length() < 2:
		seconds = "0" + seconds
	if minutes.length() < 2:
		minutes = "0" + minutes
	
	fpart = String(int(fpart * 1000))
	while(fpart.length() < 3):
		fpart = "0" + fpart
	
	time.text = hours + ":" + minutes + ":" + seconds + "." + fpart

func check_checkpoint():
	var c = checks[current_check]
	var bods = c.get_overlapping_bodies()
	
	if not bods.empty():
		if current_check == 7:
			
			lap_num += 1
			lap.text = "Lap " + String(lap_num) + " / 3"
			
			if lap_num >= 4:
				end_race()
		current_check = (current_check + 1) % checks.size()
		
func begin_race():
	is_racing = true
	$AnimationPlayer.play("Close")
	lap.text = "Lap 1 / 3"
	
	race_timer = 0.0
	lap_num = 1
	current_check = 0
	update_timer()
	
func end_race():
	var time_limit = 35.0
	if race_clam.has_won_once:
		time_limit = 30.0
	
	is_racing = false
	$AnimationPlayer.play("Open")
	
	race_clam.race_done(race_timer <= time_limit)
#

#	if race_timer <= 30.0:
#		sprocket.activate()

func _physics_process(delta):
	$Control.visible = is_racing
	if is_racing:
		race_timer += delta
		update_timer()
		check_checkpoint()
