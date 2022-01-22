extends Control

var current_dialog = null

func _ready():
	GS.dialog_ui = self
	hide()
	
func open_dialog(obj):
	if current_dialog != null:
		# I'm going to hope this check doesn't break anything...
		return
	
	if obj == null:
		return
	
	current_dialog = obj
	show()
	
	$Title.text = obj.title
	$Text.text = ""
	
	$LButton.hide()
	$RButton.hide()
	$CButton.hide()
	
	$LButton.text = obj.button_0
	$CButton.text = obj.button_0
	if obj.button_1 != null:
		$RButton.text = obj.button_1
	
	t_index = 0
	t_timer = 0.0
	
	if obj.c != null:
		obj.c.set_current(true)
		
	if obj.sound != null:
		obj.sound.play_sfx()
	
var t_timer = 0.0
var t_index = 0
func _process(delta):
	if current_dialog == null:
		hide()
		GS.camera.set_current(true)
		return
	
	if t_index < current_dialog.text.length():
		if t_timer <= 0.0:
			$Text.text += current_dialog.text[t_index]
			t_index += 1
			t_timer = 0.01 # 1 frame... lol
			
			if t_index >= current_dialog.text.length():
				if current_dialog.sound != null:
					current_dialog.sound.fade(0.2)
		else:
			t_timer -= delta
	else:
		
		if current_dialog.button_1 != null:
			$LButton.show()
			$RButton.show()
		else:
			$CButton.show()


func _on_B0():
	SFX.ui_button.play_sfx()
	
	if current_dialog == null:
		return
	var f = current_dialog.f0
	if f != null:
		f.call_func()
		
	var d = current_dialog.d0
	current_dialog = null
	open_dialog(d)


func _on_B1():
	SFX.ui_button.play_sfx()
	
	if current_dialog == null:
		return
	var f = current_dialog.f1
	if f != null:
		f.call_func()
		
	var d = current_dialog.d1
	current_dialog = null
	open_dialog(d)
