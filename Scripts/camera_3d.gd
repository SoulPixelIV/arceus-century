extends Camera3D

@export var mov_speed: float = 5.0

var card_ui = preload("res://Scenes/card_ui.tscn")

var current_hovered: Node = null  # Merkt sich das aktuell gehoverte Objekt

func _ready() -> void:
	var ui = card_ui.instantiate()
	add_child(ui)

func _process(delta: float) -> void:
	# Movement
	var direction := Vector3.ZERO
	direction.z -= 1
	translate(direction * mov_speed * delta)
	
	# Cursor Raycast
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = project_ray_origin(mouse_pos)
	var ray_direction = project_ray_normal(mouse_pos)
	var ray_length = 100.0
	
	var query = PhysicsRayQueryParameters3D.new()
	query.from = ray_origin
	query.to = ray_origin + ray_direction * ray_length
	query.collide_with_areas = true
	query.collide_with_bodies = true
	
	var space_state = get_world_3d().direct_space_state
	var result = space_state.intersect_ray(query)
	
	var collider = result.get("collider") if result else null
	
	if collider != current_hovered:
		# Falls vorher ein anderes Objekt gehovert wurde, unhover aufrufen
		if current_hovered and current_hovered.has_method("on_unhover"):
			current_hovered.on_unhover()
		
		# Neues Objekt hovern
		if collider and collider.has_method("on_hover"):
			collider.on_hover()
		
		current_hovered = collider
	
	if collider and Input.is_action_just_pressed("interact"):
		if collider.has_method("on_interact"):
			collider.on_interact()
