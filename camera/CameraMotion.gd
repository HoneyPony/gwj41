extends Spatial

var actual_velocity = Vector3.ZERO

var fish_arr = []

onready var fish_pattern = get_node("../FishPattern")

func _ready():
	
	
	var fish_root = get_parent()
	for i in range(0, 10 + 1):
		var fish = fish_root.get_node("Fish" + String(i))
		fish_arr.append(fish)
		
var sprocket_target = null

func notif_sprocket(sprocket):
	sprocket_target = sprocket
	
func notif_sprocket_end():
	sprocket_target = null
	
func get_target_fish():
	var fish_avg = Vector3.ZERO
	for fish in fish_arr:
		fish_avg += fish.transform.origin
		
	var fish_n = fish_arr.size()
	#if fish_pattern.target_position != null:
		#fish_avg += fish_pattern.target_position * 8
		#fish_n += 8
		
	fish_avg /= fish_n
	
	return fish_avg
	
func get_target_sprocket():
	return sprocket_target.global_transform.origin

func _physics_process(delta):
	var target
	if sprocket_target != null:
		target = get_target_sprocket()
	else:
		target = get_target_fish()
	
	var offset = target - $FishTarget.global_transform.origin
	
	var lerp_strength = (offset.length() - 2.0) / 4.0
	lerp_strength = clamp(lerp_strength, 0.05, 0.3)
	
	transform.origin += offset * GS.lpfa(lerp_strength) * delta
	
#	var mouse = get_viewport().get_mouse_position()
#
#	mouse.x /= get_viewport().size.x
#	mouse.y /= get_viewport().size.y
#
#	#print(mouse)
#
#	mouse.x -= 0.5
#	mouse.y -= 0.5
#
#	var velocity = Vector3.ZERO
#
#	if mouse.x > 0.45:
#		velocity += Vector3.RIGHT
#	if mouse.x < -0.45:
#		velocity -= Vector3.RIGHT
#	if mouse.y > 0.45:
#		velocity -= Vector3.UP
#	if mouse.y < -0.45:
#		velocity += Vector3.UP
#
#	velocity = velocity.normalized() * 10
#	actual_velocity += (velocity - actual_velocity) * GS.lpfa(0.2) * delta
#
#	transform.origin += actual_velocity * delta
	
