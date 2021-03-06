extends Spatial

func find_mouse_target_position():
	var camera = GS.camera
	var mouse = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse)
	var to = from + camera.project_ray_normal(mouse) * 300
	
	var space_state = get_world().direct_space_state
	var result: Dictionary = space_state.intersect_ray(from, to,
		[self], 0x80000000)
		
	if not result.empty():
		return result.position

	return null
	
#func find_mouse_geyser():
#	var camera = GS.camera
#	var mouse = get_viewport().get_mouse_position()
#	var from = camera.project_ray_origin(mouse)
#	var to = from + camera.project_ray_normal(mouse) * 300
#
#	var space_state = get_world().direct_space_state
#	var result: Dictionary = space_state.intersect_ray(from, to,
#		[self], 64)
#
#	if not result.empty():
#		return result.collider
#
#	return null

var target_position = null
var target_rotation = Basis.IDENTITY

var is_mostly_still = false

onready var starter = get_node("../StartingTarget")
var track_mouse = false

func _physics_process(delta):
	if not GS.fish_unlocked():
		return
	
	var last_target = target_position
	if track_mouse:
		target_position = find_mouse_target_position()
	else:
		target_position = starter.global_transform.origin
	

	
	if target_position != null:
		GS.mouse_position = target_position
#		var geyser_col = find_mouse_geyser()
#		if geyser_col != null:
#			var g = geyser_col.get_parent()
#			target_position.y = g.transform.origin.y + 10
		
		var dir = (target_position - transform.origin)
		if dir.length() > 0.02:

			rotation.x = cartesian2polar(dir.x, dir.y).y
			
			#var basis_tmp = transform.basis
			
			#look_at(transform.origin + dir.normalized() * 10, Vector3.UP)
			#target_rotation = transform.basis.orthonormalized()
			
			#transform.basis = basis_tmp
		
	#transform.basis = transform.basis.orthonormalized().slerp(target_rotation, GS.lpfa(0.1) * delta)

		transform.origin = target_position
		
		if last_target != null:
			var dist = (target_position - last_target).length()
			is_mostly_still = dist < 0.3
