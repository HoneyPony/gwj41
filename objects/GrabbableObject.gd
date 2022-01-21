extends KinematicBody

var is_picked_up = false
var ignore_dash_area_timer = 0.0

var frozen = false
var frozen_target = null

var flag_compute_release_velocity = false

var velocity: Vector3 = Vector3.ZERO

const gravity = Vector3(0, -30, 0)

var filtered_target = Vector3.ZERO

export var damp_accel = 15.0
export var damp_max_mul = 6.0

export(NodePath) onready var rot_target = GS.nodefp(self, rot_target)
export var do_rotate = false
export var random_rotate = false

func _ready():
	set_collision_layer_bit(7, true)
	
	if random_rotate:
		rot_target.rotate_x(rand_range(0, TAU))
		rot_target.rotate_y(rand_range(0, TAU))
		rot_target.rotate_z(rand_range(0, TAU))

func check_dash_area(delta):
	if ignore_dash_area_timer > 0.0:
		ignore_dash_area_timer -= delta
		return
		
	if GS.picked_up_object != null:
		return
		
	if GS.picked_up_timer > 0.0:
		return
	
	var bods = $DashArea.get_overlapping_bodies()
	if not bods.empty():
		is_picked_up = true
		GS.picked_up_object = self

func compute_release_velocity():
	velocity = Vector3.ZERO
	
	for fish in GS.fish_set:
		velocity += fish.velocity
		
	velocity /= GS.fish_set.size()
	
var target_basis = Basis.IDENTITY

func _physics_process(delta):
	if frozen:
		set_collision_layer_bit(3, false)
		set_collision_mask_bit(3, false)
		
		if frozen_target != null:
			var offset = (frozen_target - global_transform.origin)
			global_transform.origin += offset * GS.lpfa(0.1) * delta
		
		if is_picked_up:
			is_picked_up = false
			GS.picked_up_object = null
			GS.picked_up_timer = 0.4
			ignore_dash_area_timer = 0.25
		return
	
	set_collision_mask_bit(3, not is_picked_up)
	#set_collision_mask_bit(4, not is_picked_up)
	set_collision_layer_bit(3, not is_picked_up)
	
	if do_rotate:
		var vel = velocity
		if vel.length() > 0.05:
			vel = vel.normalized()
			if abs(vel.y) > 0.999:
				vel.x = 0.2
				vel = vel.normalized()
				
			var tmp = rot_target.transform.basis
			rot_target.look_at(rot_target.global_transform.origin + vel, Vector3.UP)
			target_basis = rot_target.transform.basis
			rot_target.transform.basis = tmp
			
		rot_target.transform.basis = rot_target.transform.basis.slerp(target_basis, GS.lpfa(0.05) * delta)

	if flag_compute_release_velocity:
		flag_compute_release_velocity = false
		compute_release_velocity()

	if is_picked_up:
		
		if Input.is_action_just_pressed("fish_dash"):
			is_picked_up = false
			GS.picked_up_object = null
			GS.picked_up_timer = 0.4
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
		
		var snap_to_zero = global_transform.origin
		snap_to_zero.x = 0
		snap_to_zero.y = 0
		snap_to_zero.z = -snap_to_zero.z
		
		move_and_collide(snap_to_zero)
