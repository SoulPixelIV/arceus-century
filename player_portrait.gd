extends TextureButton

var labels = []
var labels2 = []
var player_node = null
var card_ui_node = null
var foundPlayer = false

func _ready() -> void:
	pivot_offset = size / 2

func _process(delta: float) -> void:
	if !foundPlayer:
		labels = get_tree().get_nodes_in_group("player")
		for label in labels:
			if label.name == "Player":
				player_node = label
				foundPlayer = true
				
		labels2 = get_tree().get_nodes_in_group("cardUI")
		for label2 in labels2:
			if label2.name == "Card UI":
				card_ui_node = label2

func _on_mouse_entered() -> void:
	scale = Vector2(1.2, 1.2)

func _on_mouse_exited() -> void:
	scale = Vector2(1, 1)

func _on_button_down() -> void:
	#Use Selected Card
	if card_ui_node.card_instance_selected != null:
		player_node.health -= card_ui_node.card_instance_selected.damage
		player_node.health += card_ui_node.card_instance_selected.health_regain
		player_node.strength_buff += card_ui_node.card_instance_selected.strength_buff
		player_node.is_wet = card_ui_node.card_instance_selected.is_wet
		player_node.is_burning = card_ui_node.card_instance_selected.is_burning
		player_node.is_confused = card_ui_node.card_instance_selected.is_confused
		player_node.keylock += card_ui_node.card_instance_selected.keylock
		
		card_ui_node.card_instance_selected.card_was_used()
