extends Area

onready var camera: Camera = get_node("Camera")

var dialog
var is_talking = false

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
	
func callback_yes():
	is_talking = false
	race.begin_race()
	pass
	
func callback_no():
	is_talking = false
	pass

func begin_talking():
	if is_talking:
		return
	
	is_talking = true
	$AnimationPlayer.play("Talk")
	camera.set_current(true)
	
	print("Clam activating dialog")
	GS.open_dialog(dialog)

func _physics_process(delta):
	if race.is_racing:
		return
	
	var obj = get_overlapping_bodies()
	if not obj.empty():
		begin_talking()
