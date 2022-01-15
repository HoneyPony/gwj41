extends CPUParticles

var timer = 5.0

func _ready():
	emitting = true

func _process(delta):
	timer -= delta
	if timer <= 0:
		queue_free()
