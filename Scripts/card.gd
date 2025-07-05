extends TextureButton

var card_id = 0
var handPos = 0
var original_posX = 0
var original_posY = 0
var card_ui_parent = null
var curr_hovered = false
var card_is_selected = false

func _ready() -> void:
	pivot_offset = size / 2 #Set Pivot Point

func _on_mouse_entered() -> void:
	if !card_is_selected:
		curr_hovered = true
		z_index = 100
		scale = Vector2(1.2, 1.2)
		position += Vector2(0, -20)

func _on_mouse_exited() -> void:
	if !card_is_selected:
		curr_hovered = false
		z_index = 0
		scale = Vector2(1, 1)
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
	
#Right Click to discard Card
func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			queue_free()  # Karte löschen
			card_ui_parent.cardSlots[handPos] = 0
			card_ui_parent.currCardNum -= 1
			print("Card was discarded.")
		
func card_has_focus() -> void:
	card_is_selected = true
	z_index = 100
	scale = Vector2(1.2, 1.2)
	position = Vector2(370, 170)
