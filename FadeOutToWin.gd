extends CanvasLayer

var win = preload("res://WinMenu.tscn")

func _ready():
	GS.fade_out_obj = self

func win():
	GS.is_in_game = false
	get_tree().change_scene_to(win)
