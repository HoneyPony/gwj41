extends Spatial

export var rotate_mesh = 0

func _ready():
	$geyser.rotate_y(deg2rad(rotate_mesh))
