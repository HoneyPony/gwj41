extends Control

onready var list = [
	$B/Sprocket,
	$B/Sprocket2,
	$B/Sprocket3,
	$B/Sprocket4,
	$T/Sprocket,
	$T/Sprocket2,
	$T/Sprocket3,
	$T/Sprocket4,
	$T/Sprocket5,
	$T/Sprocket6,
	$T/Sprocket7,
	$T/Sprocket8,
]

var number_showing = 0

func hide_circles():
	for i in range(0, 4):
		list[i].get_node("Pivot/Circle").hide()

func _ready():
	call_deferred("hide_circles")
	
func show_next():
	var index = 11 - number_showing
	if index < 0: # Failsafe...
		return
		
	list[index].get_node("AnimationPlayer").play("Checkoff")
	number_showing += 1
	
func _physics_process(delta):
	while(number_showing < GS.collected_sprocket_count):
		show_next()
