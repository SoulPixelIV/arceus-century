extends Node3D

@export var spawn_timer = 1
@export var enemy_spawn_timer = 5
var spawn_timer_save = spawn_timer
var enemy_spawn_timer_save = enemy_spawn_timer
var firstSpawn = false
var tunnel_spawn_distance = 7.9;
var tunnel := preload("res://Scenes/tube_test.tscn")
var camera := preload("res://Scenes/camera_3d.tscn")
var card := preload("res://Scenes/card_ui.tscn")
var enemy := preload("res://Scenes/enemy1.tscn")
var spawned_camera: Camera3D
var spawned_card: Sprite3D

func spawn_tunnel_segment(position: Vector3) -> void:
	var tunnel_instance = tunnel.instantiate()
	tunnel_instance.position = position
	add_child(tunnel_instance)
	
func spawn_enemy1(position: Vector3) -> void:
	var enemy_instance = enemy.instantiate()
	enemy_instance.position = position
	add_child(enemy_instance)
	
func _ready() -> void:
	spawn_timer = 0
	
	#Spawn Camera
	spawned_camera = camera.instantiate()
	spawned_camera.position = Vector3(0, 0, 0)
	add_child(spawned_camera)

func _process(delta: float) -> void:
	spawn_timer -= delta
	enemy_spawn_timer -= delta
	
	#Spawn Tunnel Segment
	if spawn_timer < 0:
		if spawned_camera and spawned_camera.is_inside_tree():
			var forward_dir = -spawned_camera.global_transform.basis.z.normalized()
			if !firstSpawn:
				spawn_tunnel_segment(spawned_camera.global_transform.origin + forward_dir * 3)
				firstSpawn = true
			else:
				spawn_tunnel_segment(spawned_camera.global_transform.origin + forward_dir * tunnel_spawn_distance)
				tunnel_spawn_distance += 5
			spawn_timer = spawn_timer_save
				
	#Spawn Enemy
	if enemy_spawn_timer < 0:
		if spawned_camera and spawned_camera.is_inside_tree():
			var forward_dir = -spawned_camera.global_transform.basis.z.normalized()
			spawn_enemy1(spawned_camera.global_transform.origin + forward_dir * 5)
			enemy_spawn_timer = enemy_spawn_timer_save
