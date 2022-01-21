extends Spatial

export(NodePath) onready var sprocket = GS.nodefp(self, sprocket)

var got = false

func count(area, group):
	var arr = area.get_overlapping_bodies()
	if arr.size() < 5:
		return 0
		
	var c = 0
	for item in arr:
		if item.is_in_group(group):
			c += 1
			
	return c

func _physics_process(delta):
	if not got:
		var a1 = count($GreenArea, "GemGreen")
		if a1 < 5:
			return
		var a2 = count($RedArea, "GemRed")
		if a2 < 5:
			return	
		var a3 = count($BlueArea, "GemBlue")
		if a3 < 5:
			return
			
		got = true
		sprocket.activate()
