extends StaticBody3D

var display_name = "Holy Diver"
var health = 14
var damage = 6
var strength_buff = 0
var attack_speed = 6

var element_water = false
var keylock = 0

var attack_timer = 0
var idle_delay = 1
var idle_delay_save = idle_delay

enum States {IDLE, ATTACKING, BLOCKING}
var state: States = States.IDLE

var labels = []
var labels2 = []
var labels3 = []
var enemy_health_text = null
var enemy_health_label = null
var enemy_attack_bar = null
var player_node = null
var card_ui_node = null

func _ready() -> void:
	labels = get_tree().get_nodes_in_group("ui_labels")
	for label in labels:
		if label.name == "EnemyHealthText":
			enemy_health_text = label
		if label.name == "EnemyHealthLabel":
			enemy_health_label = label
		if label.name == "EnemyAttackBar":
			enemy_attack_bar = label
			
	labels2 = get_tree().get_nodes_in_group("player")
	for label2 in labels2:
		if label2.name == "Player":
			player_node = label2
			
	labels3 = get_tree().get_nodes_in_group("cardUI")
	for label3 in labels3:
		if label3.name == "Card UI":
			card_ui_node = label3
	
func _process(delta: float) -> void:
	enemy_health_text.text = "En. Health:"
	enemy_health_label.text = str(health)
	enemy_attack_bar.value = attack_timer
	
	#Idling
	if state == States.IDLE:
		idle_delay -= delta
		if idle_delay < 0:
			#Randomly select next State
			var rand_num = int(randf_range(1, 4))
			print(rand_num)
			match rand_num:
				1:
					state = States.IDLE
				2:
					state = States.BLOCKING
				3:
					state = States.ATTACKING
			idle_delay = idle_delay_save
			
	#BLOCKING
	if state == States.BLOCKING:
		state = States.IDLE
	
	#Attacking
	if state == States.ATTACKING:
		if attack_timer < 100:
			attack_timer += delta * attack_speed
		else:
			player_node.health -= damage
			attack_timer = 0
			state = States.IDLE

func on_hover():
	scale = Vector3(1.2, 1.2, 1.2)
	
func on_unhover():
	scale = Vector3(1, 1, 1)

func on_interact():
	#Use Selected Card
	if card_ui_node.card_instance_selected != null:
		health -= card_ui_node.card_instance_selected.damage
		health += card_ui_node.card_instance_selected.health_regain
		strength_buff += card_ui_node.card_instance_selected.strength_buff
		element_water = card_ui_node.card_instance_selected.element_water
		keylock += card_ui_node.card_instance_selected.keylock
		
		card_ui_node.card_instance_selected.card_was_used()
