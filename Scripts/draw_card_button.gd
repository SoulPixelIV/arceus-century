extends Button

var numberOfCards = 0
var maxNumberOfCards = 5
var card = preload("res://Scenes/card.tscn")
@onready var card_container = get_parent().get_node("CardContainer")

func initiateCard() -> void:
	if numberOfCards < maxNumberOfCards:
		numberOfCards += 1
		var spawnedCard = card.instantiate()
		spawnedCard.position = Vector2(30 + 40 * numberOfCards, 150)
		card_container.add_child(spawnedCard)
	
func _on_pressed() -> void:
	initiateCard()
