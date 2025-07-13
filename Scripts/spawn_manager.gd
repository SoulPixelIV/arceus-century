extends Node3D

@export var spawn_timer = 1
@export var enemy_spawn_timer = 5
var spawn_timer_save = spawn_timer
var enemy_spawn_timer_save = enemy_spawn_timer
var stop_enemy_spawn = false
var arena_already_spawned = false #Prohibits 2 arenas spawning next to each other
var firstSpawn = false
var tunnel_spawn_distance = 7.9;
var tunnel := preload("res://Scenes/tube_test.tscn")
var arena := preload("res://Scenes/battle_area1.tscn")
var camera := preload("res://Scenes/camera_3d.tscn")
var card := preload("res://Scenes/card_ui.tscn")
var enemy := preload("res://Scenes/enemy1.tscn")
var spawned_camera: Camera3D
var spawned_card: Sprite3D

#Spawn Straight Tunnel
func spawn_tunnel_segment(position: Vector3) -> void:
	var tunnel_instance = tunnel.instantiate()
	tunnel_instance.position = position
	add_child(tunnel_instance)
	
#Spawn Battle Arena
func spawn_arena_segment(position: Vector3) -> void:
	var arena_instance = arena.instantiate()
	arena_instance.position = position
	add_child(arena_instance)
	
#Spawn Enemy
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
	
	#Spawn Level Segment
	if spawn_timer < 0:
		if spawned_camera and spawned_camera.is_inside_tree():
			var forward_dir = -spawned_camera.global_transform.basis.z.normalized()
			var rand_num = int(randf_range(1, 3))
			
			if arena_already_spawned:
				rand_num = 1
				
			#Spawn Straight Tunnel
			if rand_num == 1:
				if !firstSpawn:
					spawn_tunnel_segment(spawned_camera.global_transform.origin + forward_dir * 3)
					firstSpawn = true
				else:
					spawn_tunnel_segment(spawned_camera.global_transform.origin + forward_dir * tunnel_spawn_distance)
					tunnel_spawn_distance += 5
				spawn_timer = spawn_timer_save
				arena_already_spawned = false
			#Spawn Battle Arena
			else:
				if !firstSpawn:
					spawn_arena_segment(spawned_camera.global_transform.origin + forward_dir * 3)
					firstSpawn = true
				else:
					spawn_arena_segment(spawned_camera.global_transform.origin + forward_dir * tunnel_spawn_distance)
					tunnel_spawn_distance += 5
				spawn_timer = spawn_timer_save * 3 #Longer Delay because Battle Arena is longer then tunnel
				arena_already_spawned = true
				
	#Spawn Enemy
	if !stop_enemy_spawn:
		if enemy_spawn_timer < 0:
			if spawned_camera and spawned_camera.is_inside_tree():
				var forward_dir = -spawned_camera.global_transform.basis.z.normalized()
				spawn_enemy1(spawned_camera.global_transform.origin + forward_dir)
				enemy_spawn_timer = enemy_spawn_timer_save
				spawned_camera.moving = false
				stop_enemy_spawn = true
