extends Button

func _on_pressed() -> void:
	var currCamera = get_node("res://Scenes/camera_3d.tscn")
	currCamera.initiateCard()
