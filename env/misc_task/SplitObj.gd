extends Spatial

export(NodePath) onready var sprocket = GS.nodefp(self, sprocket)

var got = false

func _physics_process(delta):
	if not got:
		var a1 = $Area1.get_overlapping_bodies()
		if a1.empty():
			return
		var a2 = $Area2.get_overlapping_bodies()
		if a2.empty():
			return
			
		got = true
		sprocket.activate()
