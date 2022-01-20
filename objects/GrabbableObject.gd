extends KinematicBody

var is_picked_up = false
var ignore_dash_area_timer = 0.0

var flag_compute_release_velocity = false

var velocity: Vector3 = Vector3.ZERO

const gravity = Vector3(0, -30, 0)

var filtered_target = Vector3.ZERO

export var damp_accel = 15.0
export var damp_max_mul = 6.0

func check_dash_area(delta):
	if ignore_dash_area_timer > 0.0:
		ignore_dash_area_timer -= delta
		return
	
	var bods = $DashArea.get_overlapping_bodies()
	if not bods.empty():
		is_picked_up = true

func compute_release_velocity():
	velocity = Vector3.ZERO
	
	for fish in GS.fish_set:
		velocity += fish.velocity
		
	velocity /= GS.fish_set.size()

func _physics_process(delta):

	if flag_compute_release_velocity:
		flag_compute_release_velocity = false
		compute_release_velocity()

	if is_picked_up:
		if Input.is_action_just_pressed("fish_dash"):
			is_picked_up = false
			ignore_dash_area_timer = 0.25
			flag_compute_release_velocity = true
			
		var target_position = Vector3.ZERO
		for fish in GS.fish_set:
			target_position += fish.global_transform.origin
			
		target_position /= GS.fish_set.size()
		
#		var closest = GS.fish_set[0].transform.origin
#		var closest_dist = (closest - target_position).length_squared() + (closest - transform.origin).length_squared()
#		for fish in GS.fish_set:
#			var dist = (fish.transform.origin - target_position).length_squared() + (fish.transform.origin - transform.origin).length_squared()
#			if dist < closest_dist:
#				closest = fish.transform.origin
#				closest_dist = dist
#
#		if closest_dist > 4:
#			target_position = closest
#
#		filtered_target += (target_position - filtered_target) * GS.lpfa(0.3) * delta
#
		var max_dist_moved = (3 * 60 * delta)
		var dif = target_position - global_transform.origin
		if dif.length_squared() > (max_dist_moved * max_dist_moved):
			dif = dif.normalized() * max_dist_moved
			
		move_and_collide(dif)
	else:
		check_dash_area(delta)
		
		var vel_xz = velocity
		vel_xz.y = 0
		var decel_strength = vel_xz.length() / 10
		decel_strength = clamp(decel_strength, 0.7, damp_max_mul)
		var decel = -vel_xz.normalized() * damp_accel * delta * decel_strength
		
		if decel.length() > vel_xz.length():
			vel_xz = Vector3.ZERO
		else:
			vel_xz += decel
			
		velocity.x = vel_xz.x
		velocity.z = vel_xz.z
			
		velocity += gravity * delta
			
		velocity = move_and_slide(velocity)
