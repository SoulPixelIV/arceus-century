extends StaticBody3D

var display_name = "Holy Diver"
var health = 14
var damage = 6
var strength_buff = 0
var attack_speed = 8
var block_strength = 6
var block_speed = 12

var is_wet = false
var is_burning = false
var is_confused = false

var burn_duration = 0
var burn_tick = 1

var keylock = 0

var attack_timer = 0
var idle_delay = 1

var idle_delay_save = idle_delay
var block_length = 0
var block_strength_save = block_strength

enum States {IDLE, ATTACKING, BLOCKING}
var state: States = States.IDLE

var labels = []
var labels2 = []
var labels3 = []
var enemy_health_text = null
var enemy_health_label = null
var block_text = null
var block_label = null
var enemy_attack_bar = null
var player_node = null
var card_ui_node = null

var shield_texture: Texture2D = preload("res://Textures/shield_icon_small.png")
var shield_sprite: Sprite3D

var flame_texture: Texture2D = preload("res://Textures/flame_icon.png")
var flame_sprite: Sprite3D
var water_texture: Texture2D = preload("res://Textures/water_icon.png")
var water_sprite: Sprite3D
var conf_texture: Texture2D = preload("res://Textures/conf_icon.png")
var conf_sprite: Sprite3D

func _ready() -> void:
	labels = get_tree().get_nodes_in_group("ui_labels")
	for label in labels:
		if label.name == "EnemyHealthText":
			enemy_health_text = label
		if label.name == "EnemyHealthLabel":
			enemy_health_label = label
		if label.name == "EnemyAttackBar":
			enemy_attack_bar = label
		if label.name == "BlockText":
			block_text = label
		if label.name == "BlockLabel":
			block_label = label
			
	labels2 = get_tree().get_nodes_in_group("player")
	for label2 in labels2:
		if label2.name == "Player":
			player_node = label2
			
	labels3 = get_tree().get_nodes_in_group("cardUI")
	for label3 in labels3:
		if label3.name == "Card UI":
			card_ui_node = label3
			
	#Create Shield Icon
	shield_sprite = Sprite3D.new()
	shield_sprite.texture = shield_texture
	shield_sprite.position = Vector3(0, 0, 0.1)
	shield_sprite.visible = false
	add_child(shield_sprite)
	
	#Create Flame Icon
	flame_sprite = Sprite3D.new()
	flame_sprite.texture = flame_texture
	flame_sprite.position = Vector3(0.4, 0, 0.1)
	flame_sprite.visible = false
	add_child(flame_sprite)
	
	#Create Water Icon
	water_sprite = Sprite3D.new()
	water_sprite.texture = water_texture
	water_sprite.position = Vector3(0.5, 0, 0.1)
	water_sprite.visible = false
	add_child(water_sprite)
	
	#Create Confusion Icon
	conf_sprite = Sprite3D.new()
	conf_sprite.texture = conf_texture
	conf_sprite.position = Vector3(0.6, 0, 0.1)
	conf_sprite.visible = false
	add_child(conf_sprite)
	
func _process(delta: float) -> void:
	enemy_health_text.text = "En. Health:"
	enemy_health_label.text = str(health)
	if state == States.IDLE:
		enemy_attack_bar.value = 0
	if state == States.BLOCKING:
		enemy_attack_bar.value = block_length
	if state == States.ATTACKING:
		enemy_attack_bar.value = attack_timer	
	
	#Idling
	if state == States.IDLE:
		idle_delay -= delta
		if idle_delay < 0:
			#Randomly select next State
			var rand_num = int(randf_range(1, 4))
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
		shield_sprite.visible = true
		block_text.text = "Block:"
		block_label.text = str(block_strength)
		block_length += delta * block_speed
		if block_length >= 100 or block_strength <= 0:
			shield_sprite.visible = false
			block_text.text = ""
			block_label.text = ""
			block_length = 0
			block_strength = block_strength_save
			state = States.IDLE
	
	#Attacking
	if state == States.ATTACKING:
		if attack_timer < 100:
			attack_timer += delta * attack_speed
		else:
			player_node.health -= damage
			attack_timer = 0
			state = States.IDLE
			
	#Burning
	if is_burning:
		flame_sprite.visible = true
		burn_duration -= delta
		burn_tick -= delta
		
		if burn_tick <= 0:
			health -= 1
			burn_tick = 1
			
		if burn_duration <= 0:
			burn_duration = 0
			is_burning = false
	else:
		flame_sprite.visible = false
		
	#Wet	
	if is_wet:
		water_sprite.visible = true
	else:
		water_sprite.visible = false
		
	#Confused
	if is_confused:
		conf_sprite.visible = true
	else:
		conf_sprite.visible = false

func on_hover():
	scale = Vector3(1.2, 1.2, 1.2)
	
func on_unhover():
	scale = Vector3(1, 1, 1)

func on_interact():
	#Use Selected Card
	if card_ui_node.card_instance_selected != null:
		if state == States.BLOCKING:
			if block_strength - card_ui_node.card_instance_selected.damage >= 0:
				block_strength -= card_ui_node.card_instance_selected.damage
			else:
				health -= card_ui_node.card_instance_selected.damage - block_strength
				block_strength = 0
		else:
			health -= card_ui_node.card_instance_selected.damage
		health += card_ui_node.card_instance_selected.health_regain
		strength_buff += card_ui_node.card_instance_selected.strength_buff
		if card_ui_node.card_instance_selected.is_wet:
			is_wet = card_ui_node.card_instance_selected.is_wet
		if card_ui_node.card_instance_selected.is_burning:
			is_burning = card_ui_node.card_instance_selected.is_burning
		if card_ui_node.card_instance_selected.is_confused:
			is_confused = card_ui_node.card_instance_selected.is_confused			
		burn_duration += card_ui_node.card_instance_selected.burn_duration
		keylock += card_ui_node.card_instance_selected.keylock
		
		card_ui_node.card_instance_selected.card_was_used()
