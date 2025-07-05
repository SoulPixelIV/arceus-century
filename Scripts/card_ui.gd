extends Control

@export var cardTimerSpeed = 30

var card = preload("res://Scenes/card.tscn")
var deckLabel = null
var deck = []
var deck_size = 10
var deck_index = 0
var maxNumberOfCards = 5
var cardSlots = [0, 0, 0, 0, 0]
var currCardNum = 0
var card_is_selected = false

@onready var card_container = $CardContainer
@onready var timer_bar = $TimerBar

func _ready() -> void:
	deckLabel = get_node("DeckLabel")
	
	#Fill Deck with Starter Cards
	for i in range(deck_size):
		deck.append(randi_range(0, 14))
	
	#Timer Bar
	timer_bar.value = 100
	
func _process(delta: float) -> void:		
	#Update Deck Counter
	deckLabel.text = str(deck_size - deck_index)
	
	print(cardSlots)
	
	#Timer Bar
	if timer_bar.value < 100:
		timer_bar.value += delta * cardTimerSpeed

func initiateCard() -> void:
	currCardNum = 0
	#Fill Hand with 1s(Cards)           [1,1,1,0,0] -> means player has 3 cards in hand
	for i in range(cardSlots.size()):
		if cardSlots[i] == 0:
			cardSlots[i] = 1
			break
		currCardNum += 1
		
	if currCardNum < 5 and deck_size - deck_index > 0:	
		timer_bar.value = 0
		var spawnedCard = card.instantiate()
		spawnedCard.card_ui_parent = self
		spawnedCard.handPos = currCardNum
		spawnedCard.position = Vector2(100 + 60 * currCardNum, 280)
		spawnedCard.original_posX = 100 + 60 * currCardNum
		spawnedCard.original_posY = 280
		spawnedCard.card_id = deck[deck_index]
		spawnedCard.texture_normal = load_texture_from_folder("res://Textures/Cards/", deck[deck_index])
		deck_index += 1
		card_container.add_child(spawnedCard)
		
func load_texture_from_folder(path: String, index: int) -> Texture2D:
	var file_path = "%scard_%d.png" % [path, index]
	var tex = load(file_path)
	return tex if tex else null

func _on_draw_card_button_pressed() -> void:
	if timer_bar.value == 100.0: 
		initiateCard()
