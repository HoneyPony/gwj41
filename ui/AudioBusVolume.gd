extends HSlider

export var bus_name = "Music"

var bus

func _ready():
	bus = AudioServer.get_bus_index(bus_name)
	to_value()

func to_bus():
	AudioServer.set_bus_volume_db(bus, linear2db(value)) 
	
func to_value():
	value = db2linear(AudioServer.get_bus_volume_db(bus))
	
func _process(delta):
	to_bus()
