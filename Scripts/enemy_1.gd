extends StaticBody3D

var display_name = "Holy Diver"
var health = 14

var labels = []
var enemy_health_text = null
var enemy_health_label = null

func _ready() -> void:
	labels = get_tree().get_nodes_in_group("ui_labels")
	for label in labels:
		if label.name == "EnemyHealthText":
			enemy_health_text = label
		if label.name == "EnemyHealthLabel":
			enemy_health_label = label
	
func _process(delta: float) -> void:
	enemy_health_text.text = "En. Health:"
	enemy_health_label.text = str(health)

func on_hover():
	scale = Vector3(1.2, 1.2, 1.2)
	
func on_unhover():
	scale = Vector3(1, 1, 1)
