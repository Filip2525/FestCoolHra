extends GPUParticles2D

@onready var timer = $Timer

func _ready() -> void:
	timer.timeout.connect(on_timeout)
	emitting = true
	
func on_timeout() -> void:
	print("freeing")
	queue_free()
