extends Sprite3D

var camera = Camera3D

func _process(delta: float) -> void:
	var forward_dir = -camera.global_transform.basis.z.normalized()
	var up_dir = camera.global_transform.basis.y.normalized()
	
	#Position card at lower bottom part of screen
	position = camera.global_transform.origin + forward_dir * 1 - up_dir * 0.8
