extends TextureButton

func _ready() -> void:
	pivot_offset = size / 2

func _on_mouse_entered() -> void:
	scale = Vector2(1.2, 1.2)

func _on_mouse_exited() -> void:
	scale = Vector2(1, 1)
