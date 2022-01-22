extends Spatial

#onready var gem_material: SpatialMaterial = $GemButton/Circle.get_active_material(1)

export(NodePath) onready var target_door = GS.nodefp(self, target_door)

var is_pressed = false

export var stay_pressed = true

func make_pressed():
	if is_pressed:
		return
	
	is_pressed = true
	$AnimationPlayer.play("TurnOn")
	
	SFX.button_on.play()
	
	if target_door is Node:
		target_door.get_node("AnimationPlayer").play("Open")

func _physics_process(delta):
	if is_pressed:
		if stay_pressed:
			return
			
	var items = $Itemcheck.get_overlapping_bodies()
	for item in items:
		if item.is_in_group("GemGreen"):
			if item.velocity.length() < 1:
				make_pressed()
				return
				
	if items.empty():
		if is_pressed:
			is_pressed = false
			$AnimationPlayer.play("TurnOff")
			SFX.button_off.play()
			
			if target_door is Node:
				target_door.get_node("AnimationPlayer").play("Close")
