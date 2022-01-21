extends Area

onready var camera: Camera = get_node("Camera")

var dialog
var is_talking = false

func _ready():
	dialog = GS.Dialog.new("Speedy Sam", "You there! Are you up for a race around the track?", "Yes", "No")
	dialog.on_0(null, funcref(self, "callback_yes"))
	dialog.on_1(null, funcref(self, "callback_no"))
	
func callback_yes():
	is_talking = false
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
	var obj = get_overlapping_bodies()
	if not obj.empty():
		begin_talking()
