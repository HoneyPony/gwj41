extends Spatial

onready var model_pivot = $Pivot
onready var model = $Pivot/Sprocket

func _physics_process(delta):
	model_pivot.rotate_y(delta * TAU * 0.25)
	model.rotate_z(delta * TAU * 0.75)
	
