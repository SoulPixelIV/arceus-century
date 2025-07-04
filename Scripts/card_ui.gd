extends Control

@export var cardTimerSpeed = 30

var card = preload("res://Scenes/card.tscn")
var cardTextures = load_textures_from_folder("res://Textures/Cards/")
var maxNumberOfCards = 5
var cardSlots = [0, 0, 0, 0, 0]
var currCardNum = 0
var card_is_selected = false

@onready var card_container = $CardContainer
@onready var timer_bar = $TimerBar

func _ready() -> void:
	timer_bar.value = 100
	
func _process(delta: float) -> void:		
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
		spawnedCard.position = Vector2(100 + 60 * currCardNum, 260) #280
		spawnedCard.original_posX = 90 + 60 * currCardNum #100 +
		spawnedCard.original_posY = 260 #280
		spawnedCard.scale = Vector2(0.75, 0.75)
		if cardTextures.size() > 0:
			var random_tex = cardTextures[randi() % cardTextures.size()]
			spawnedCard.texture_normal = random_tex
		card_container.add_child(spawnedCard)
		
func load_textures_from_folder(path: String) -> Array:
	var result = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				if file_name.ends_with(".png") or file_name.ends_with(".jpg"):
					var tex = load(path + file_name)
					if tex:
						result.append(tex)
			file_name = dir.get_next()
		dir.list_dir_end()
	return result

func _on_draw_card_button_pressed() -> void:
	if timer_bar.value == 100.0: 
		initiateCard()
