extends Node3D

var health = 30
var money = 0

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
