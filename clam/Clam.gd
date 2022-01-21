extends Area

onready var camera: Camera = get_node("Camera")

var dialog

var dialog_won
var dialog_lost
var is_talking = false

var has_won_once = false

export(NodePath) onready var race = GS.nodefp(self, race)

func _ready():
	var no = funcref(self, "callback_no")
	var yes = funcref(self, "callback_yes")
	
	var d2 = GS.Dialog.new("Speedy Sam", "You will have to complete 3 laps in 35 seconds.", "Let's go!", "Actually, nevermind...")
	d2.on_0(null, yes)
	d2.on_1(null, no)
	
	dialog = GS.Dialog.new("Speedy Sam", "You there! Are you up for a race around the track?", "Yes", "No")
	dialog.on_0(d2)
	dialog.on_1(null, no)
	
	dialog_won = GS.Dialog.new("Speedy Sam", "Wow! Nice job there! Here, take this sprocket I have as a trophy!", "Hooray!")
	dialog_won.on_0(null, funcref(self, "callback_won"))
	
	dialog_lost = GS.Dialog.new("Speedy Sam", "Sorry, not quite within 35 seconds there. But, you can always try again!", "OK...")
	dialog_lost.on_0(null, no)
	
func callback_yes():
	is_talking = false
	race.begin_race()
	pass
	
func callback_no():
	is_talking = false
	pass
	
func callback_won():
	is_talking = false
	if not has_won_once:
		race.sprocket.activate()
		has_won_once = true
	
func race_done(won):
	is_talking = true
	if won:
		
		GS.open_dialog(dialog_won)
	else:
		GS.open_dialog(dialog_lost)

func begin_talking():
	if is_talking:
		return
	
	is_talking = true
	$AnimationPlayer.play("Talk")
	camera.set_current(true)
	
	#print("Clam activating dialog")
	GS.open_dialog(dialog)

func _physics_process(delta):
	if race.is_racing:
		return
	
	var obj = get_overlapping_bodies()
	if not obj.empty():
		begin_talking()
