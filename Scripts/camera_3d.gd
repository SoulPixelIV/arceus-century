extends Camera3D

@export var mov_speed: float = 5.0

var card_ui = preload("res://Scenes/card_ui.tscn")

func _ready() -> void:
	var ui = card_ui.instantiate()
	add_child(ui)

func _process(delta: float) -> void:
	var direction := Vector3.ZERO #Direction is a 3 dimensional vector (0,0,0)
	direction.z -= 1
	translate(direction * mov_speed * delta)
