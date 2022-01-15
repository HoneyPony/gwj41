extends Spatial

var actual_velocity = Vector3.ZERO

func _physics_process(delta):
	var mouse = get_viewport().get_mouse_position()
	
	mouse.x /= get_viewport().size.x
	mouse.y /= get_viewport().size.y
	
	#print(mouse)
	
	mouse.x -= 0.5
	mouse.y -= 0.5
	
	var velocity = Vector3.ZERO
	
	if mouse.x > 0.45:
		velocity += Vector3.RIGHT
	if mouse.x < -0.45:
		velocity -= Vector3.RIGHT
	if mouse.y > 0.45:
		velocity -= Vector3.UP
	if mouse.y < -0.45:
		velocity += Vector3.UP
		
	velocity = velocity.normalized() * 10
	actual_velocity += (velocity - actual_velocity) * GS.lpfa(0.2) * delta
		
	transform.origin += actual_velocity * delta
	
