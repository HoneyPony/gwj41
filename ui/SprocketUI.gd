extends Control

var should_leave_screen = false
var leave_sprocket = null

func notif_sprocket(sprocket):
	$AnimationPlayer.play("FadeIn")
	should_leave_screen = false
	leave_sprocket = sprocket
	
	$SprocketName.text = '"' + sprocket.sprocket_name + '"'

func notif_sprocket_end(sprocket):
	$AnimationPlayer.play("FadeOut")

func enable_done():
	should_leave_screen = true
	
func _process(delta):
	if should_leave_screen:
		if Input.is_action_just_pressed("fish_dash"):
			should_leave_screen = false
			
			for node in get_tree().get_nodes_in_group("SprocketNotif"):
				node.notif_sprocket_end(leave_sprocket)
