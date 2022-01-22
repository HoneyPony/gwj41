extends Spatial

var dialog

var timer = 1.5

var tut_needed = true

onready var red_cam = get_node("../Camera")
onready var yel_cam = get_node("../../Fish2/Camera")
onready var blu_cam = get_node("../../Fish6/Camera")

onready var tut_y = get_node("../../Level/TutorialY")

var dialog_dash

func _ready():
	var d0 = GS.Dialog.new("Blue the Engineer", "Captain, I believe we need to find 8 sprockets to fix it up.")
	
	var d1 = GS.Dialog.new("Captain Redfin", "A mighty fine plan... what do we do first?")
	
	var d2 = GS.Dialog.new("Yellowtail the Quick", "We can use the mouse pointer to move around.")
	
	var d3 = GS.Dialog.new("Captain Redfin", "Let's do that then... and keep an eye out for sprockets!")
	
	dialog = GS.Dialog.new("Captain Redfin", "Yarrrrgghhh... It seems we have crashed our beloved ship...")
	dialog.cam(red_cam).on_0(d0)
	d0.cam(blu_cam).on_0(d1)
	d1.cam(red_cam).on_0(d2)
	d2.cam(yel_cam).on_0(d3)
	d3.cam(red_cam).on_0(null, funcref(self, "dialog_done"))
	
	dialog_dash = GS.Dialog.new("Yellowtail the Quick", "Captain, all these bubbles reminds me...")
	var dd0 = GS.Dialog.new("Captain Redfin", "Reminds you of what?")
	var dd1 = GS.Dialog.new("Yellowtail the Quick", "Well, if we click the left mouse button, we can dash around!")
	var dd2 = GS.Dialog.new("Captain Redfin", "And how does that help us?")
	var dd3 = GS.Dialog.new("Yellowtail the Quick", "It'll let us get through walls of bubbles, and interact with other stuff as well!")
	var dd4 = GS.Dialog.new("Blue the Engineer", "Yeah, like, we can dash into sprockets to collect them!")
	var dd5 = GS.Dialog.new("Captain Redfin", "Very well... let's get dashing.")
	
	dialog_dash.cam(yel_cam).on_0(dd0)
	dd0.cam(red_cam).on_0(dd1)
	dd1.cam(yel_cam).on_0(dd2)
	dd2.cam(red_cam).on_0(dd3)
	dd3.cam(yel_cam).on_0(dd4)
	dd4.cam(blu_cam).on_0(dd5)
	dd5.cam(red_cam)
	

func dialog_done():
	get_node("../../FishPattern").track_mouse = true

func start_dialog():
	red_cam.set_current(true)
	
	
	GS.open_dialog(dialog)

func _process(delta):
	if timer >= 0.0:
		timer -= delta
		if timer < 0.0:
			start_dialog()
			
	if tut_needed:
		if global_transform.origin.y > tut_y.global_transform.origin.y:
			GS.open_dialog(dialog_dash)
			tut_needed = false
