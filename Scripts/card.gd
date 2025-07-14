extends TextureButton

var card_id = 0
var handPos = 0
var original_posX = 0
var original_posY = 0
var card_ui_parent = null
var curr_hovered = false
var card_is_selected = false

var damage = 0

var health_regain = 0
var strength_buff = 0

var is_wet = false
var is_burning = false
var is_confused = false

var burn_duration = 0

var keylock = 0

func _ready() -> void:
	#Set Card Values
	match card_id:
		0:
			strength_buff = 2
		1:
			is_wet = true
		2:
			keylock = 1
		3:
			is_confused = true
		4:
			health_regain = 3
		5:
			health_regain = 5
		6:
			health_regain = 2
		7:
			health_regain = 10
		8:
			health_regain = 2
		9:
			is_burning = true
			burn_duration = 8
		10:
			damage = 2
		11:
			damage = 5
		12:
			damage = 5
		13:
			damage = 3
		14:
			is_burning = true
			burn_duration = 3
	
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
		card_ui_parent.card_instance_selected = self
		card_has_focus()
	elif card_is_selected:
		card_ui_parent.card_is_selected = false
		card_ui_parent.card_instance_selected = null
		z_index = 0
		scale = Vector2(1, 1)
		position = Vector2(original_posX, original_posY - 20)
		card_is_selected = false
	
#Right Click to discard Card
func card_was_used() -> void:
	card_ui_parent.cardSlots[handPos] = 0
	card_ui_parent.currCardNum -= 1
	card_ui_parent.currCardsInHand -= 1
	card_ui_parent.card_is_selected = false
	card_ui_parent.card_instance_selected = null
	queue_free()  # Karte löschen
		
func card_has_focus() -> void:
	card_is_selected = true
	z_index = 100
	scale = Vector2(1.2, 1.2)
	position = Vector2(370, 170)
