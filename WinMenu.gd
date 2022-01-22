extends Spatial

func _ready():
	$Control/SCount.text = "You found " + String(GS.collected_sprocket_count) + " sprockets!"
	$Control/TCount.text = "Your game took " + String(GS.mins) + " minutes!"

func _on_Quit_pressed():
	get_tree().quit()
