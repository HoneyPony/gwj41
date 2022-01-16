extends Label

func _process(delta):
	text = "FPS: " + String(Engine.get_frames_per_second()) + " Dimensions: " + String(get_viewport().size)
