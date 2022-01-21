extends Node

var camera
var fish_set = []

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

