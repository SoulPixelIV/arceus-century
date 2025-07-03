extends TextureButton

var handPos = 0
var card_ui_parent = null

func _ready() -> void:
	pivot_offset = size / 2

func _on_mouse_entered() -> void:
	scale = Vector2(1.2, 1.2)

func _on_mouse_exited() -> void:
	scale = Vector2(1, 1)

func _on_button_down() -> void:
	if !card_ui_parent.card_selected:
		card_ui_parent.card_selected = true
		card_ui_parent.arrow_start_pos = position
