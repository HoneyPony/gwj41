extends Spatial

onready var drill = $Drill/Drill
onready var gear = $Drill/Gear/Gear

func process_geode(item, delta):
	#print("process gedoe")
	var rt = item.rot_target
	var s = rt.scale.x
	s -= delta * 0.7
	
	if s <= 0.3 and not item.frozen:
		item.get_node("AnimationPlayer").play("Break")
		item.frozen = true
		
		item.frozen_target = global_transform.origin + Vector3(0, 5, 0)
		
		var contents = item.get_node_or_null("Contents")
		if contents != null:
			contents.activate()
			SFX.gem_upfare.play_usual()
		
		#print("Froze the geode")
		return
	
	rt.scale.x = s
	rt.scale.y = s
	rt.scale.z = s
	
	

func _physics_process(delta):
	drill.rotate_y(TAU * 2 * delta)
	gear.rotate_y(TAU * 1 * delta)

	var drill_items = $DrillArr.get_overlapping_bodies()
	for item in drill_items:
		if item.is_in_group("Geode"):
			process_geode(item, delta)
			
#		if not SFX.rock_break.playing:
#			SFX.rock_break.play_sfx()
