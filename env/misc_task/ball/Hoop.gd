extends Spatial

export(NodePath) onready var sprocket = GS.nodefp(self, sprocket)

var balls = 0

var got = false


func _on_BallDetect_body_exited(body):
	if got:
		return
	
	if body.is_in_group("GemBall"):
		balls += 1
		
		if balls >= 3:
			got = true
			sprocket.activate()
