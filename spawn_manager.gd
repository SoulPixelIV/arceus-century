extends Node3D

@export var spawn_timer = 1
var spawn_timer_save = spawn_timer
var firstSpawn = false
var tunnel := preload("res://Scenes/tunnel.tscn")
var camera := preload("res://Scenes/camera_3d.tscn")
var spawned_camera: Camera3D

func spawn_tunnel_segment(position: Vector3) -> void:
	var tunnel_instance = tunnel.instantiate()
	tunnel_instance.position = position
	add_child(tunnel_instance)
	
func _ready() -> void:
	spawn_timer = 0
	spawned_camera = camera.instantiate()
	spawned_camera.position = Vector3(0, 0, 0)
	add_child(spawned_camera)

func _process(delta: float) -> void:
	spawn_timer -= delta
	if spawn_timer < 0:
		if spawned_camera and spawned_camera.is_inside_tree():
			var forward_dir = -spawned_camera.global_transform.basis.z.normalized()
			if firstSpawn:
				spawn_tunnel_segment(spawned_camera.global_transform.origin + forward_dir * 15)
			else:
				var tunnelIndex = 1
				for i in range(15):
					spawn_tunnel_segment(spawned_camera.global_transform.origin + forward_dir * tunnelIndex)
					tunnelIndex += 1
				firstSpawn = true
				
		spawn_timer = spawn_timer_save
