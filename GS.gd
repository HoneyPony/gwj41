extends Node

var camera
var fish_set = []

func lpfa(a):
	return a * 60.0
	
func nodefp(src, path):
	if src != null and path != null:
		return src.get_node(path)
		
	return null

var fish_avg = Vector3.ZERO

func _physics_process(delta):
	fish_avg = Vector3.ZERO
	
	for fish in fish_set:
		fish_avg += fish.transform.origin
		
	fish_avg /= fish_set.size()
