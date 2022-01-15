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

var target_position = null
var target_rotation = Basis.IDENTITY

func _physics_process(delta):
	target_position = find_mouse_target_position()
	
	if target_position != null:
		var dir = (target_position - transform.origin)
		if dir.length() > 0.02:

			rotation.x = cartesian2polar(dir.x, dir.y).y
			
			#var basis_tmp = transform.basis
			
			#look_at(transform.origin + dir.normalized() * 10, Vector3.UP)
			#target_rotation = transform.basis.orthonormalized()
			
			#transform.basis = basis_tmp
		
	#transform.basis = transform.basis.orthonormalized().slerp(target_rotation, GS.lpfa(0.1) * delta)

		transform.origin = target_position
