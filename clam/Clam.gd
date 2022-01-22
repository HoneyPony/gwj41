extends Area

onready var camera: Camera = get_node("Camera")

var dialog

var dialog_hard_race
var dialog_last_race

var dialog_won
var dialog_won_h
var dialog_lost
var dialog_lost_h
var is_talking = false

var has_won_once = false
var has_won_twice = false

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
	
	var dh2 = GS.Dialog.new("Speedy Sam", "You will have to complete 3 laps in only 30 seconds!", "Let's go!", "Actually, nevermind...")
	dh2.on_0(null, yes)
	dh2.on_1(null, no)
	
	dialog_hard_race = GS.Dialog.new("Speedy Sam", "You there! You've won one race, but can you win another?", "Maybe...", "Nah")
	dialog_hard_race.on_0(dh2)
	dialog_hard_race.on_1(null, no)
	
	dialog_last_race = GS.Dialog.new("Speedy Sam", "You've beaten all the races I can offer. But you can always go again anyways...", "Let's go!", "Maybe later...")
	dialog_last_race.on_0(null, yes)
	dialog_last_race.on_1(null, no)
	
	dialog_won = GS.Dialog.new("Speedy Sam", "Wow! Nice job there! Here, take this sprocket I have as a trophy!", "Hooray!")
	dialog_won.on_0(null, funcref(self, "callback_won"))
	
	dialog_won_h = GS.Dialog.new("Speedy Sam", "Wow! Incredible job there! Here, take a second sprocket!", "Hooray!")
	dialog_won_h.on_0(null, funcref(self, "callback_won"))
	
	dialog_lost = GS.Dialog.new("Speedy Sam", "Sorry, not quite within 35 seconds there. But, you can always try again!", "OK...")
	dialog_lost.on_0(null, no)
	
	dialog_lost_h = GS.Dialog.new("Speedy Sam", "Darn, not quite within 30 seconds. You can always try again!", "OK...")
	dialog_lost_h.on_0(null, no)
	
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
	else:
		if not has_won_twice:
			race.sprocket2.activate()
			has_won_twice = true
	
func race_done(won):
	if has_won_twice:
		return
	
	is_talking = true
	if won:
		var d = dialog_won
		if has_won_once:
			d = dialog_won_h
		GS.open_dialog(d)
	else:
		var d = dialog_lost
		if has_won_once:
			d = dialog_lost_h
		GS.open_dialog(d)

func begin_talking():
	if is_talking:
		return
	
	is_talking = true
	$AnimationPlayer.play("Talk")
	camera.set_current(true)
	
	#print("Clam activating dialog")
	var d = dialog
	if has_won_once:
		d = dialog_hard_race
	if has_won_twice:
		d = dialog_last_race
	GS.open_dialog(d)

func _physics_process(delta):
	if not is_talking:
		$AnimationPlayer.play("Normal")
	
	if race.is_racing:
		return
	
	var obj = get_overlapping_bodies()
	if not obj.empty():
		begin_talking()
