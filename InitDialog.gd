extends Spatial

var dialog

var timer = 1.5

var tut_needed = true

onready var red_cam = get_node("../Camera")
onready var yel_cam = get_node("../../Fish2/Camera")
onready var blu_cam = get_node("../../Fish6/Camera")

onready var tut_y = get_node("../../Level/TutorialY")

onready var sprocket_list = get_node("../../SprocketList")

var dialog_dash

var dialog_s1
var dialog_s8
var dialog_s12

var dialog_ship
var dialog_ship_12

func _ready():
	GS.fish_dialog = self
	
	var d0 = GS.Dialog.new("Blue the Engineer", "Captain, I believe we need to find 8 sprockets to fix it up.")
	
	var d1 = GS.Dialog.new("Captain Redfin", "A mighty fine plan... what do we do first?")
	
	var d2 = GS.Dialog.new("Yellowtail the Quick", "We can use the mouse pointer to move around.")
	
	var d3 = GS.Dialog.new("Captain Redfin", "Let's do that then... and keep an eye out for sprockets!")
	
	dialog = GS.Dialog.new("Captain Redfin", "Yarrrrgghhh... It seems we have crashed our beloved ship...")
	dialog.cam(red_cam).on_0(d0, funcref(self, "show_sprockets")).sfx(SFX.red_talk)
	d0.cam(blu_cam).on_0(d1).sfx(SFX.blue_talk)
	d1.cam(red_cam).on_0(d2).sfx(SFX.red_talk)
	d2.cam(yel_cam).on_0(d3).sfx(SFX.yellow_talk)
	d3.cam(red_cam).on_0(null, funcref(self, "dialog_done")).sfx(SFX.red_talk)
	
	dialog_dash = GS.Dialog.new("Yellowtail the Quick", "Captain, all these bubbles reminds me...")
	var dd0 = GS.Dialog.new("Captain Redfin", "Reminds you of what?")
	var dd1 = GS.Dialog.new("Yellowtail the Quick", "Well, if we click the left mouse button, we can dash around!")
	var dd2 = GS.Dialog.new("Captain Redfin", "And how does that help us?")
	var dd3 = GS.Dialog.new("Yellowtail the Quick", "It'll let us get through walls of bubbles, and interact with other stuff as well!")
	var dd4 = GS.Dialog.new("Blue the Engineer", "Yeah, like, we can dash into sprockets to collect them!")
	var dd5 = GS.Dialog.new("Captain Redfin", "Very well... let's get dashing.")
	
	dialog_dash.cam(yel_cam).on_0(dd0).sfx(SFX.yellow_talk)
	dd0.cam(red_cam).on_0(dd1).sfx(SFX.red_talk)
	dd1.cam(yel_cam).on_0(dd2).sfx(SFX.yellow_talk)
	dd2.cam(red_cam).on_0(dd3).sfx(SFX.red_talk)
	dd3.cam(yel_cam).on_0(dd4).sfx(SFX.yellow_talk)
	dd4.cam(blu_cam).on_0(dd5).sfx(SFX.blue_talk)
	dd5.cam(red_cam).sfx(SFX.red_talk)
	
	dialog_s1 = GS.Dialog.new("Blue the Engineer", "Alright, that's one sprocket down, 7 to go!!")
	dialog_s1.cam(blu_cam).sfx(SFX.blue_talk)
	
	dialog_s8 = GS.Dialog.new("Blue the Engineer", "We have 8 sprockets now! We can head back to the ship and fix it!")
	var ds8_0 = GS.Dialog.new("Yellowtail the Quick", "Or we can keep looking for sprockets, just for fun!!")
	var ds8_1 = GS.Dialog.new("Blue the Engineer", "True, a couple spares wouldn't hurt. It's your call captain...")
	dialog_s8.cam(blu_cam).on_0(ds8_0).sfx(SFX.blue_talk)
	ds8_0.cam(yel_cam).on_0(ds8_1).sfx(SFX.yellow_talk)
	ds8_1.cam(blu_cam).sfx(SFX.blue_talk)
	
	dialog_s12 = GS.Dialog.new("Blue the Engineer", "Wow captain, I'm pretty sure that's the last sprocket we can find out here.")
	var ds12_0 = GS.Dialog.new("Yellowtail the Quick", "Yeah, might as well head back to the ship, probably...")
	dialog_s12.cam(blu_cam).on_0(ds12_0).sfx(SFX.blue_talk)
	ds12_0.cam(yel_cam).sfx(SFX.yellow_talk)
	
	dialog_ship = GS.Dialog.new("Blue the Engineer", "Alright everyone, we have enough sprockets to fix our ship!")
	var dship0 = GS.Dialog.new("Captain Redfin", "So... should we fix up our ship and leave?", "Yeah, let's leave!", "No, let's keep exploring")
	var dship1 = GS.Dialog.new("Captain Redfin", "We're sure we should leave?", "Absolutely!", "Actually, maybe not...")
	
	dialog_ship.cam(blu_cam).on_0(dship0).sfx(SFX.blue_talk)
	dship0.cam(red_cam).on_0(dship1).sfx(SFX.red_talk)
	dship1.cam(red_cam).on_0(null, funcref(self, "leave")).sfx(SFX.red_talk)
	
	dialog_ship_12 = GS.Dialog.new("Blue the Engineer", "Alright everyone, we have as many sprockets as we can possibly get!")
	dialog_ship_12.cam(blu_cam).on_0(dship0).sfx(SFX.blue_talk)
	
var done_s1 = false
var done_s8 = false
var done_s12 = false

func show_sprockets():
	sprocket_list.get_node("AnimationPlayer").play("ShowUp")

func dialog_done():
	get_node("../../FishPattern").track_mouse = true
	
func leave():
	GS.fade_out_obj.get_node("AnimationPlayer").play("FadeOut")

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
	
	if not done_s1 and GS.collected_sprocket_count >= 1:
		done_s1 = true
		GS.open_dialog(dialog_s1)
		
	if not done_s8 and GS.collected_sprocket_count >= GS.needed_sprockets:
		done_s8 = true
		GS.open_dialog(dialog_s8)

	if not done_s12 and GS.collected_sprocket_count >= GS.max_sprockets:
		done_s12 = true
		GS.open_dialog(dialog_s12)
	
func ship():
	var d = dialog_ship
	if GS.collected_sprocket_count >= GS.max_sprockets:
		d = dialog_ship_12
	GS.open_dialog(dialog_ship)
