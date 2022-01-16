extends Spatial

var weeds_left = 4

var cooldown = 0.0
var col_timer = -1
var del_timer = -1

func was_hit():
	#print("was hit")
	if weeds_left == 4:
		#$Weed3.queue_free()
		$Particles2.emitting = true
		del_timer = 0.2
	if weeds_left == 3:
		#$Weed3.queue_free()
		$Particles1.emitting = true
		del_timer = 0.2
	if weeds_left == 2:
		#$Weed2.queue_free()
		$Particles0.emitting = true
		#$Collision.queue_free()
		col_timer = 0.3
		del_timer = 0.2
		
	weeds_left -= 1

func _physics_process(delta):
	if cooldown <= 0.0:
		var bods = $Area.get_overlapping_bodies()
		if not bods.empty():
			cooldown = 0.4
			was_hit()
	else:
		cooldown -= delta
		
	if col_timer > 0.0:
		col_timer -= delta
		if col_timer <= 0.0:
			$Collision.queue_free()
			
	if del_timer > 0.0:
		del_timer -= delta
		if del_timer <= 0.0:
			if weeds_left == 3:
				$Weed4.queue_free()
			elif weeds_left == 2:
				$Weed3.queue_free()
			else:
				$Weed2.queue_free()
