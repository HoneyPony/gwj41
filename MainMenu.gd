extends Spatial

var Game = preload("res://Game.tscn")

func change_scene():
	get_tree().change_scene_to(Game)
	
func _on_Play_pressed():
	$CanvasLayer/AnimationPlayer.play("FadeOut")



func _on_Quit_pressed():
	get_tree().quit()
