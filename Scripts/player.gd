extends Node3D

var health = 30
var strength_buff = 0
var money = 0

var is_wet = false
var is_burning = false
var is_confused = false

var keylock = 0

var labels = []
var health_label = null
var money_label = null

func _ready() -> void:
	labels = get_tree().get_nodes_in_group("ui_labels")
	for label in labels:
		if label.name == "HealthLabel":
			health_label = label
		if label.name == "MoneyLabel":
			money_label = label
	
func _process(delta: float) -> void:
	health_label.text = str(health)
	money_label.text = str(money)
	
	#Restart Scene on Death
	if health <= 0:
		var current_scene = get_tree().current_scene
		get_tree().reload_current_scene()
