extends KinematicBody

var target_position = null
var velocity: Vector3

export var fish_color: Color = Color(0xff8600ff)

export var acceleration_strength = 10
export var movement_speed = 20

export(NodePath) onready var fish_mesh = GS.nodefp(self, fish_mesh)
export(NodePath) onready var fish_anim = GS.nodefp(self, fish_anim)

export var max_anim_speed = 4

onready var pivot = $FishRot

onready var dash_shape = $DashCollider/CollisionShape

export(NodePath) onready var fish_pattern = GS.nodefp(self, fish_pattern)

export var fish_number: int = 0

onready var fish_target = GS.nodefp(fish_pattern, "Fish" + String(fish_number))

var dash_timer = 0.0

func _ready():
	fish_mesh.get_active_material(0).albedo_color = fish_color
	
	dash_shape.disabled = true
	
	GS.fish_set.append(self)

func find_target_position():
	return fish_target.global_transform.origin
	
var target_rotation: Basis

# This function computes the current acceleration based on the desired velocity.
# In particular, it will never accelerate faster than the desired velocity, so the
# acceleration * delta vector is properly clamped so as to not over-accelerate.
func compute_acceleration(desired_velocity: Vector3, delta: float, zero_threshold: float = 0.0) -> Vector3:
	var accel_direction = (desired_velocity - velocity).normalized()
	
	var ast = acceleration_strength
	if velocity.length() > movement_speed:
		ast *= 4
	
	var delta_accel_strength = ast * delta
	
	# By default the zero-threshold is set to 0, so we will only decelerate if
	# the input velocity is exactly 0. This is fine for the player script, which
	# directly returns Vector3.ZERO, but may not be fine in other circumstances--
	# in which case the zero_threshold may be set accordingly.
#	if (desired_velocity - Vector3.ZERO).length_squared() <= zero_threshold * zero_threshold:
#		delta_accel_strength *= drift_acceleration_multiplier
#	elif desired_velocity.dot(velocity) < 0:
#		# Don't apply back-accel at same time as drift.
#		delta_accel_strength *= back_acceleration_multiplier
	
	var max_acceleration = (desired_velocity - velocity).length()
	var actual_accel_amount = min(max_acceleration, delta_accel_strength)
	
	return accel_direction * actual_accel_amount
	
func get_input_vector():
	pass
	


func process_movement(delta, should_go_towards_target):
	var distance = (target_position - transform.origin).length()
#	if distance < velocity.length() and distance < 0.05:
#		distance = 0
#		transform.origin = target_position

	
	var input_vector: Vector3 = (target_position - transform.origin)#get_input_vector()
	
	var distance_there = input_vector.length()
	input_vector = input_vector.normalized()
	var desired_velocity: Vector3 = input_vector * min(movement_speed, sqrt(2 * acceleration_strength * distance_there))
	
	
	
	# This is a nice bit of physics to calculate when we should be decelerating
	# based on our current velocity, in order to reach the target position right
	# on time.
	var position_boundary_for_deceleration = velocity.length_squared() / (2.0 * acceleration_strength)
	
	var should_be_decelerating = distance <= position_boundary_for_deceleration
	
	if not should_go_towards_target:
		should_be_decelerating = false
		desired_velocity = Vector3.ZERO
	
	if should_be_decelerating:
		var accel_strength = acceleration_strength
#		if distance > 0.01:
#			accel_strength = velocity.length_squared() / (2.0 * distance)
			#print("compare: ", accel_strength, " vs ", acceleration_strength)
		#print("decelerating ", velocity)
		var acceleration: Vector3 = -velocity.normalized() * accel_strength
		acceleration *= delta
		
		var max_acceleration = velocity.length()
		if acceleration.length() > max_acceleration:
			acceleration = acceleration.normalized() * max_acceleration
			
		velocity += acceleration # already multiplied by delta
		if velocity.length_squared() < 0.5 * 0.5:
			velocity = Vector3.ZERO
	else:
		var acceleration: Vector3 = compute_acceleration(desired_velocity, delta)	
		velocity += acceleration
		
	for fish in get_tree().get_nodes_in_group("PlayerFish"):
		if fish == self:
			continue
			
		var dif = fish.transform.origin - transform.origin
		dif.z = 0
		var repel_strength = 1.0 - clamp((dif).length() / 0.8, 0.0, 1.0)
		
		velocity += repel_strength * dif.normalized() * -1.0
	
		
	
	velocity = move_and_slide(velocity)
	
func process_pivot_rotation(delta):
	if target_position != null:
		var dir = (target_position - transform.origin)
		if velocity.length() > 1:
			
			var basis_tmp = pivot.transform.basis
			
			pivot.look_at(pivot.global_transform.origin + velocity.normalized() * 10, Vector3.UP)
			target_rotation = pivot.transform.basis.orthonormalized()
			
			pivot.transform.basis = basis_tmp
		else:
			var mouse = fish_pattern.target_position
			var fish = GS.fish_avg
			
			if mouse != null:
				if mouse.x >= fish.x:
					target_rotation = Basis(Vector3.UP, deg2rad(-90))
				else:	
					target_rotation = Basis(Vector3.UP, deg2rad(90))
			
#			var look_target = fish_pattern.target_position
#			if look_target != null:
#				if (look_target - transform.origin).length_squared() > 0.5:
#					var basis_tmp = pivot.transform.basis
#
#					pivot.look_at(look_target, Vector3.UP)
#					target_rotation = pivot.transform.basis.orthonormalized()
#
#					pivot.transform.basis = basis_tmp
#
	pivot.transform.basis = pivot.transform.basis.orthonormalized().slerp(target_rotation, GS.lpfa(0.07) * delta)

var jitter_z = 0.0

var DashParticles = preload("res://fish/DashParticles.tscn")

func process_anim(delta):
	var val = (velocity.length() / (movement_speed * 1.2))
	fish_anim.animation_speed = clamp(val, 1.5, max_anim_speed)

func _physics_process(delta):
	var should_go_towards_target = true
	
	var new_target = find_target_position()
	if new_target != null:
		if target_position == null:
			target_position = new_target
		target_position = new_target
	
		if fish_pattern.is_mostly_still:
			var mouse = fish_pattern.target_position
			if mouse != null:
				if (mouse - transform.origin).length() < 2:
					should_go_towards_target = false
			if (target_position - transform.origin).length() < 0.8:
				should_go_towards_target = false
	
	
		#target_position += (new_target - target_position) * GS.lpfa(0.05) * delta
		
		#print(target_position)
	process_pivot_rotation(delta)

	process_movement(delta, should_go_towards_target)
	
	if Input.is_action_just_pressed("fish_dash"):
		if dash_timer <= 0.0:
		
			var mouse = fish_pattern.target_position
			if mouse != null:
				var dir = (mouse - transform.origin).normalized()
				velocity += (dir * movement_speed * 3)
				velocity = velocity.normalized() * movement_speed * 1.4
				var dp = DashParticles.instance()
				add_child(dp)
				
				dash_timer = 0.4
	dash_shape.disabled = dash_timer <= 0.2
	dash_timer = max(dash_timer - delta, -1)
	
	set_collision_mask_bit(5, dash_timer <= -0.2)
	
	var jitter_z_uf = rand_range(-2.0, 2.0)
	jitter_z += (jitter_z_uf - jitter_z) * GS.lpfa(0.01) * delta
	
	var target_z = clamp(velocity.x / 10.0, -2.0, 2.0) + jitter_z
	pivot.transform.origin.z += (target_z - pivot.transform.origin.z) * GS.lpfa(0.05) * delta
