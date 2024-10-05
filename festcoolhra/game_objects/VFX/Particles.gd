extends Node2D

var emitting_set: bool = false

@onready var timer = $Timer

func explode() -> void:
	for child in get_children():
		if child is GPUParticles2D:
			child.emitting = true
			emitting_set = true
			
func _process(delta: float) -> void:
	for child in get_children():
		if child is GPUParticles2D:
			if emitting_set:
				break
			else:
				child.emitting = false
	
	emitting_set = false
	
