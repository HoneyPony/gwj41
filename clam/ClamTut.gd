extends Area

onready var camera: Camera = get_node("Camera")

var dialog
var dialog_post

var is_talking = false

var has_talked = false

func _ready():
	var no = funcref(self, "callback_no")
	var yes = funcref(self, "callback_yes")
	
	var d4 = GS.Dialog.new("Tutorializer Tam", "Note you can also throw things through flowering walls.", "I'll keep that in mind...")
	var d3 = GS.Dialog.new("Tutorializer Tam", "Then you can dash again to throw it!", "Neato!")
	var d2 = GS.Dialog.new("Tutorializer Tam", "You can dash into that green gem to my right to pick it up...", "Then what?")
	
	d4.on_0(null, no).sfx(SFX.clam_talk)
	d3.on_0(d4).sfx(SFX.clam_talk)
	d2.on_0(d3).sfx(SFX.clam_talk)
	
	var d1 = GS.Dialog.new("Tutorializer Tam", "Up above there's a green gate that you really should open...", "How do I do that?")
	d1.on_0(d2).sfx(SFX.clam_talk)
	
	dialog = GS.Dialog.new("Tutorializer Tam", "Hello fishes!!!!", "Hello...")
	dialog.on_0(d1).sfx(SFX.clam_talk)
	
	dialog_post = GS.Dialog.new("Tutorializer Tam", "Hello fishes!!!! I heard if you want to find something shiny, you should\nfollow the geysers way on the right of town!!!!", "Hmmm....")
	dialog_post.on_0(null, no).sfx(SFX.clam_talk)
	
#func callback_yes():
#	is_talking = false
#	pass
#
func callback_no():
	is_talking = false
	pass
#
#func callback_sprocket():
#	is_talking = false
#	has_got = true
#	sprocket.activate()
#	pass
#
#
func begin_talking():
	if is_talking:
		return
		
	has_talked = true
	is_talking = true
	$AnimationPlayer.play("Talk")
	camera.set_current(true)

	GS.open_dialog(dialog)
	
func begin_talking_2():
	if is_talking:
		return
		
	is_talking = true
	$AnimationPlayer.play("Talk")
	camera.set_current(true)

	GS.open_dialog(dialog_post)

func _physics_process(delta):
	if not is_talking:
		$AnimationPlayer.play("Normal")

	if not has_talked:
		var obj = get_overlapping_bodies()
		if not obj.empty():
			begin_talking()
	else:
		var obj = $Dash.get_overlapping_bodies()
		if not obj.empty():
			begin_talking_2()
