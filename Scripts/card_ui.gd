extends Control

@export var cardTimerSpeed = 30

var card = preload("res://Scenes/card.tscn")
var arrowTexture = preload("res://Textures/arrow.png")
var maxNumberOfCards = 5
var cardSlots = [0, 0, 0, 0, 0]
var currCardNum = 0
var arrow = null
var arrow_start_pos = Vector2(0, 0)
var card_selected = false
var arrow_spawned = false

@onready var card_container = $CardContainer
@onready var timer_bar = $TimerBar

func _ready() -> void:
	timer_bar.value = 100
	
func _process(delta: float) -> void:
	#Card Arrow
	if card_selected:
		if !arrow_spawned:
			arrow = TextureRect.new()
			arrow.texture = arrowTexture
			arrow.position = Vector2(100, 100)
			add_child(arrow)
			arrow_spawned = true
	else:
		arrow_spawned = false
		
	if arrow != null:
		var from_pos = arrow_start_pos  # Position, z. B. von der Karte
		var to_pos = get_viewport().get_mouse_position()
		var arrow_direction = to_pos - from_pos
		var arrow_distance = arrow_direction.length()
		var arrow_angle = arrow_direction.angle()

		arrow.global_position = from_pos
		arrow.rotation = arrow_angle
		var base_width = arrow.texture.get_width()
		arrow.pivot_offset = Vector2(0, arrowTexture.get_height() / 2.0)
		arrow.stretch_mode = TextureRect.STRETCH_SCALE
		arrow.scale.x = arrow_distance / base_width
		
	#Release Arrow
	if Input.is_action_just_pressed("exit"):
		if card_selected:
			arrow.queue_free()
			card_selected = false
		
	#Timer Bar
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
		spawnedCard.position = Vector2(100 + 60 * currCardNum, 280)
		card_container.add_child(spawnedCard) 

func _on_draw_card_button_pressed() -> void:
	if timer_bar.value == 100.0: 
		initiateCard()
