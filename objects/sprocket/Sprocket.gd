extends Spatial

onready var model_pivot = $Pivot
onready var model = $Pivot/Sprocket

export var sprocket_name = "My Sprocket"

var is_collected = false

export var fish_lerp: float = 0.0 

func check_collection():
	if is_collected:
		return
		
	var dash_bods = $DashCol.get_overlapping_bodies()
	if not dash_bods.empty():
		is_collected = true
		
		for node in get_tree().get_nodes_in_group("SprocketNotif"):
			node.notif_sprocket(self)

func _physics_process(delta):
	model_pivot.rotate_y(delta * TAU * 0.25)
	model.rotate_z(delta * TAU * 0.75)
	
	check_collection()
	
	global_transform.origin = global_transform.origin.linear_interpolate(GS.fish_avg, fish_lerp)
	
func notif_sprocket(sprocket):
	pass
	
func notif_sprocket_end():
	$AnimationPlayer.play("SprocketCollect")
		
	
