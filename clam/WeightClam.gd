extends Area

onready var camera: Camera = get_node("Camera")

var dialog
var dialog_post

var dialog_thanks

var is_talking = false
var has_got = false

export(NodePath) onready var sprocket = GS.nodefp(self, sprocket)

func _ready():
	var no = funcref(self, "callback_no")
	var yes = funcref(self, "callback_yes")
	
	dialog = GS.Dialog.new("Powerlifter Pam", "Yo! Have you seen any weights lying around? I lost one of mine...", "I'll keep an eye out")
	dialog.on_0(null, no).sfx(SFX.clam_talk)
	
	dialog_post = GS.Dialog.new("Powerlifter Pam", "Yo! I heard shooting 3 hoops at the gym might score you another sprocket!", "Nice")
	dialog_post.on_0(null, no).sfx(SFX.clam_talk)
	
	dialog_thanks = GS.Dialog.new("Powerlifter Pam", "Yo! Thanks for finding my missing weight! Here, have this sprocket...", "Neato!")
	dialog_thanks.on_0(null, funcref(self, "callback_sprocket")).sfx(SFX.clam_talk)
	
func callback_yes():
	is_talking = false
	pass
	
func callback_no():
	is_talking = false
	pass
	
func callback_sprocket():
	is_talking = false
	has_got = true
	sprocket.activate()
	pass


func begin_talking():
	if is_talking:
		return
	
	is_talking = true
	$AnimationPlayer.play("Talk")
	camera.set_current(true)
	
	var d = dialog
	if has_got:
		d = dialog_post
	GS.open_dialog(d)
	
onready var weight_area = $WeightArea

func _physics_process(delta):
	if not is_talking:
		$AnimationPlayer.play("Normal")
	
	if not has_got:
		var items = weight_area.get_overlapping_bodies()
		for item in items:
			if item.is_in_group("WeightObj"):
				#has_got = true
				is_talking = true
				GS.open_dialog(dialog_thanks)
	
	var obj = get_overlapping_bodies()
	if not obj.empty():
		begin_talking()
