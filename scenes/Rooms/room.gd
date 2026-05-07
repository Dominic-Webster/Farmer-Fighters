extends Node2D
class_name Room

@onready var art : Sprite2D = $Floor
@onready var player_spawn_c : Marker2D = $"Player Spawns/PlayerSpawnC"
@onready var player_spawn_t : Marker2D = $"Player Spawns/PlayerSpawnT"
@onready var player_spawn_r : Marker2D = $"Player Spawns/PlayerSpawnR"
@onready var player_spawn_d : Marker2D = $"Player Spawns/PlayerSpawnD"
@onready var player_spawn_l : Marker2D = $"Player Spawns/PlayerSpawnL"
@onready var doors : Node2D = $Doors
@onready var enemy_spawns : Node2D = $EnemySpawns

@export var enemy_scenes : Array[PackedScene]

var enemy_count : int = 0


func _enter_room(dir_from : String) -> void:
	var player = RunManager.player
	
	match dir_from:
		"C":
			player.global_position = player_spawn_c.global_position
		"U":
			player.global_position = player_spawn_t.global_position
		"R":
			player.global_position = player_spawn_r.global_position
		"D":
			player.global_position = player_spawn_d.global_position
		"L":
			player.global_position = player_spawn_l.global_position
	
	load_enemies(dir_from)
	if enemies_exist():
		lock_doors()
	else:
		spawn_open_doors()


func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("opendoor"):
		unlock_doors()


func load_enemies(_player_spawn : String) -> void:
	var spawns : Array[int] = []
	var counter : int = 0
	
	if _player_spawn == "C":
		spawns.append(0)
		spawns.append(5)
		spawns.append(18)
	elif _player_spawn == "U":
		spawns.append(18)
		spawns.append(20)
		spawns.append(23)
	elif _player_spawn == "R":
		spawns.append(0)
		spawns.append(6)
		spawns.append(18)
	elif _player_spawn == "D":
		spawns.append(0)
		spawns.append(2)
		spawns.append(5)
	elif _player_spawn == "L":
		spawns.append(5)
		spawns.append(11)
		spawns.append(23)
	else:
		spawns.append(0)
	
	for spawn in enemy_spawns.get_children():
		if counter in spawns:
			var scene = enemy_scenes.pick_random()
			var enemy = scene.instantiate()
			enemy.global_position = spawn.global_position
		
			add_child(enemy)
		
			enemy_count += 1
		
			enemy.died.connect(_on_enemy_died)
		counter += 1


func _on_enemy_died():
	enemy_count -= 1
	
	if enemy_count == 0:
		unlock_doors()


func lock_doors() -> void:
	for door in doors.get_children():
		if door is Door:
			door.lock_door()


func unlock_doors() -> void:
	for door in doors.get_children():
		if door is Door:
			door.unlock_door()


func spawn_open_doors() -> void:
	for door in doors.get_children():
		if door is Door:
			door.spawn_open()


func enemies_exist() -> bool:
	if enemy_count == 0:
		return false
	else:
		return true


func set_floor(desc : String) -> void:
	if desc == "Start":
		art.texture = load("res://scenes/Rooms/start_room.png")
