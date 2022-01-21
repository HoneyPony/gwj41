extends Node

class Dialog:
	var title
	var text

	var button_0
	var button_1
	
	var d0 = null
	var f0 = null
	
	var d1 = null
	var f1 = null
	
	func _init(title_, text_, button_0_ = "Next", button_1_ = null):
		title = title_
		text = text_
		button_0 = button_0_
		button_1 = button_1_
		
	func on_0(dialog, fref = null):
		d0 = dialog
		f0 = fref
		return self
		
	func on_1(dialog, fref = null):
		d1 = dialog
		f1 = fref
		return self
		

var camera
var fish_set = []

var dialog_ui = null

func fish_unlocked():
	return GS.lock_fish_sprocket_count <= 0 and camera.current

func open_dialog(obj):
	dialog_ui.open_dialog(obj)

var camera_pivot = null

var picked_up_object = null
var picked_up_timer = -1.0
var picked_up_lock = 1.0

var lock_fish_sprocket_count = 0

var mouse_position = Vector3.ZERO

func lpfa(a):
	return a * 60.0
	
func nodefp(src, path):
	if src != null and path != null:
		return src.get_node(path)
		
	return null

var fish_avg = Vector3.ZERO

func _physics_process(delta):
	picked_up_timer = max(-1.0, picked_up_timer - delta)
	picked_up_lock = min(1.0, picked_up_lock + delta)
	
	fish_avg = Vector3.ZERO
	
	for fish in fish_set:
		fish_avg += fish.transform.origin
		
	fish_avg /= fish_set.size()
	
	#print("timer: ", picked_up_timer)
	#print("the node: ", picked_up_object)

