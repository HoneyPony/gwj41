extends Spatial

#onready var gem_material: SpatialMaterial = $GemButton/Circle.get_active_material(1)

export(NodePath) onready var target_door = GS.nodefp(self, target_door)

var is_pressed = false

func make_pressed():
	is_pressed = true
	$AnimationPlayer.play("TurnOn")
	
	if target_door is Node:
		target_door.get_node("AnimationPlayer").play("Open")

func _physics_process(delta):
	if is_pressed:
		return
		
	var items = $Itemcheck.get_overlapping_bodies()
	for item in items:
		if item.is_in_group("GemGreen"):
			if item.velocity.length() < 1:
				make_pressed()
				return
