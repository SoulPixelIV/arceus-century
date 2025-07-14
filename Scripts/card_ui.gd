extends Control

@export var cardTimerSpeed = 30

var card = preload("res://Scenes/card.tscn")
var player = preload("res://Scenes/player.tscn")
var deckLabel = null
var deck = []
var deck_size = 10
var deck_index = 0
var maxNumberOfCards = 5
var cardSlots = [0, 0, 0, 0, 0]
var currCardNum = 0
var currCardsInHand = 0
var card_is_selected = false
var card_instance_selected = null

@onready var card_container = $CardContainer
@onready var timer_bar = $TimerBar
@onready var draw_card_button = $DrawCardButton
@onready var discard_pile_button = $DiscardPileButton

func _ready() -> void:
	var spawned_player = player.instantiate()
	add_child(spawned_player)
	
	deckLabel = get_node("DeckLabel")
	
	#Fill Deck with Starter Cards
	for i in range(deck_size):
		deck.append(randi_range(0, 14))
	
	#Timer Bar
	timer_bar.value = 100
	
func _process(delta: float) -> void:		
	#Update Deck Counter
	deckLabel.text = str(deck_size - deck_index)
	
	#Timer Bar
	if timer_bar.value < 100:
		timer_bar.value += delta * cardTimerSpeed
		
	#Draw Card Button Glow
	if deck_size - deck_index != 0:
		if timer_bar.value == 100:
			draw_card_button.add_theme_color_override("font_color", Color(1.0, 0.8, 0.2))
			draw_card_button.add_theme_color_override("font_focus_color", Color(1.0, 0.8, 0.2))
			draw_card_button.add_theme_color_override("font_pressed_color", Color(1.0, 0.8, 0.2))
		else:
			draw_card_button.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))
			draw_card_button.add_theme_color_override("font_focus_color", Color(1.0, 1.0, 1.0))
			draw_card_button.add_theme_color_override("font_pressed_color", Color(1.0, 1.0, 1.0))
		
	#Draw Discard Pile Glow
	if deck_size - deck_index == 0 and currCardsInHand == 0:
		discard_pile_button.add_theme_color_override("font_color", Color(1.0, 0.8, 0.2))
		discard_pile_button.add_theme_color_override("font_focus_color", Color(1.0, 0.8, 0.2))
		discard_pile_button.add_theme_color_override("font_pressed_color", Color(1.0, 0.8, 0.2))
	else:
		discard_pile_button.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))
		discard_pile_button.add_theme_color_override("font_focus_color", Color(1.0, 1.0, 1.0))
		discard_pile_button.add_theme_color_override("font_pressed_color", Color(1.0, 1.0, 1.0))

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
		currCardsInHand += 1
		card_container.add_child(spawnedCard)
		
func load_texture_from_folder(path: String, index: int) -> Texture2D:
	var file_path = "%scard_%d.png" % [path, index]
	var tex = load(file_path)
	return tex if tex else null

func _on_draw_card_button_pressed() -> void:
	if timer_bar.value == 100.0: 
		initiateCard()

func _on_discard_pile_button_button_down() -> void:
	if deck_size - deck_index == 0 and currCardsInHand == 0:
		cardSlots = [0, 0, 0, 0, 0]
		deck_index = 0
		
