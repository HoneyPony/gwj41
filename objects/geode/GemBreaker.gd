extends Spatial

onready var model_pivot = $Pivot
onready var model = $Pivot/Sprocket

func _ready():
	hide()
	
func on_spawn():
	pass
	
func on_spawn_end():
	get_parent().queue_free()
	
func activate():
	var arr = [
		"Pivot/Sprocket/Blue",
		"Pivot/Sprocket/Green",
		"Pivot/Sprocket/Red"
	]
	
	arr.shuffle()
	get_node(arr[0]).show()
	
	$AnimationPlayer.play("SprocketSpawn")
