extends Control

@export var cardTimerSpeed = 30

var card = preload("res://Scenes/card.tscn")
var maxNumberOfCards = 5
var cardSlots = [0, 0, 0, 0, 0]
var currCardNum = 0
@onready var card_container = $CardContainer
@onready var timer_bar = $TimerBar

func _ready() -> void:
	timer_bar.value = 100
	
func _process(delta: float) -> void:
	if timer_bar.value < 100:
		timer_bar.value += delta * cardTimerSpeed

func initiateCard() -> void:
	currCardNum = 0
	for i in range(cardSlots.size()):
		if cardSlots[i] == 0:
			cardSlots[i] = 1
			break
		currCardNum += 1
		
	if currCardNum < 5:	
		timer_bar.value = 0
		var spawnedCard = card.instantiate()
		spawnedCard.card_ui_parent = self
		spawnedCard.handPos = currCardNum
		spawnedCard.position = Vector2(60 + 40 * currCardNum, 150)
		card_container.add_child(spawnedCard) 

func _on_draw_card_button_pressed() -> void:
	if timer_bar.value == 100.0: 
		initiateCard()
