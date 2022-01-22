extends ColorRect

func _ready():
	hide()

func pause_toggle():
	get_tree().paused = not get_tree().paused
	visible = get_tree().paused
	 
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pause_toggle()
		
	if visible:
		mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_Resume_pressed():
	pause_toggle()


func _on_Quit_pressed():
	get_tree().quit()
