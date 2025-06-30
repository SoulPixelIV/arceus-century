extends Camera3D

@export var mov_speed: float = 5.0

func _process(delta: float) -> void:
	var direction := Vector3.ZERO #Direction is a 3 dimensional vector (0,0,0)
	direction.z -= 1
	translate(direction * mov_speed * delta)
