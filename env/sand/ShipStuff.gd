extends Area

var timer = -1.0

func _physics_process(delta):
	
	
	if GS.collected_sprocket_count >= 8:
		timer = max(timer - delta, -1.0)
		
		var bods = get_overlapping_bodies()
		if not bods.empty():
			GS.fish_dialog.ship()
			timer = 0.4
