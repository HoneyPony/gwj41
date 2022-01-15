extends KinematicBody

var target_position: Vector3
var velocity: Vector3

export var acceleration_strength = 10
export var movement_speed = 20

onready var pivot = $FishRot

export(NodePath) onready var fish_pattern = GS.nodefp(self, fish_pattern)

export var fish_number: int = 0

onready var fish_target = GS.nodefp(fish_pattern, "Fish" + String(fish_number))

func find_target_position():
	return fish_target.global_transform.origin
	
var target_rotation: Basis

# This function computes the current acceleration based on the desired velocity.
# In particular, it will never accelerate faster than the desired velocity, so the
# acceleration * delta vector is properly clamped so as to not over-accelerate.
func compute_acceleration(desired_velocity: Vector3, delta: float, zero_threshold: float = 0.0) -> Vector3:
	var accel_direction = (desired_velocity - velocity).normalized()
	
	var delta_accel_strength = acceleration_strength * delta
	
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

func process_movement(delta):
	var distance = (target_position - transform.origin).length()
	if distance < velocity.length() and distance < 0.05:
		distance = 0
		transform.origin = target_position

	
	var input_vector: Vector3 = (target_position - transform.origin).normalized()#get_input_vector()
	
	var desired_velocity: Vector3 = input_vector * movement_speed
	
	
	
	# This is a nice bit of physics to calculate when we should be decelerating
	# based on our current velocity, in order to reach the target position right
	# on time.
	var position_boundary_for_deceleration = velocity.length_squared() / acceleration_strength
	
	var should_be_decelerating = distance < position_boundary_for_deceleration
	
	if should_be_decelerating:
		#print("decelerating ", velocity)
		var acceleration: Vector3 = -velocity.normalized() * acceleration_strength
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
	
	velocity = move_and_slide(velocity)
	
func process_pivot_rotation(delta):
	if target_position != null:
		var dir = (target_position - transform.origin)
		if velocity.length() > 1:
			
			var basis_tmp = pivot.transform.basis
			
			pivot.look_at(pivot.transform.origin + velocity.normalized() * 10, Vector3.UP)
			target_rotation = pivot.transform.basis.orthonormalized()
			
			pivot.transform.basis = basis_tmp
		
	pivot.transform.basis = pivot.transform.basis.orthonormalized().slerp(target_rotation, GS.lpfa(0.1) * delta)


func _physics_process(delta):
	var new_target = find_target_position()
	if new_target != null:
		target_position = new_target
	
	process_pivot_rotation(delta)

	process_movement(delta)
