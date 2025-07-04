extends TextureButton

var handPos = 0
var original_posX = 0
var original_posY = 0
var card_ui_parent = null
var curr_hovered = false
var card_is_selected = false

func _ready() -> void:
	pivot_offset = size / 2

func _on_mouse_entered() -> void:
	if !card_is_selected:
		curr_hovered = true
		z_index = 100
		scale = Vector2(0.85, 0.85) #1.2
		position += Vector2(0, -20)

func _on_mouse_exited() -> void:
	if !card_is_selected:
		curr_hovered = false
		z_index = 0
		scale = Vector2(0.75, 0.75) #1.0
		position -= Vector2(0, -20)

func _on_button_down() -> void:
	if curr_hovered and !card_ui_parent.card_is_selected:
		card_ui_parent.card_is_selected = true
		card_has_focus()
	elif card_is_selected:
		card_ui_parent.card_is_selected = false
		z_index = 0
		scale = Vector2(1, 1)
		position = Vector2(original_posX, original_posY - 20)
		card_is_selected = false
		
func card_has_focus() -> void:
	card_is_selected = true
	z_index = 100
	scale = Vector2(0.85, 0.85) #1.2
	position = Vector2(370, 170)
