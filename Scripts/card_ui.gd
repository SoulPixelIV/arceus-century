extends Control

@export var numberOfCards = 0 
@export var maxNumberOfCards = 5
@export var cardTimerSpeed = 30

var card = preload("res://Scenes/card.tscn") 
@onready var card_container = $CardContainer
@onready var timer_bar = $TimerBar
	
func _process(delta: float) -> void:
	if timer_bar.value < 100:
		timer_bar.value += delta * cardTimerSpeed

func initiateCard() -> void: 
	numberOfCards += 1 
	timer_bar.value = 0
	var spawnedCard = card.instantiate() 
	spawnedCard.position = Vector2(30 + 40 * numberOfCards, 150) 
	card_container.add_child(spawnedCard) 

func _on_draw_card_button_pressed() -> void:
	if numberOfCards < maxNumberOfCards and timer_bar.value == 100.0: 
		initiateCard()
