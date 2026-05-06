extends Node2D
class_name Room

@onready var player_spawn_c : Marker2D = $"Player Spawns/PlayerSpawnC"
@onready var player_spawn_t : Marker2D = $"Player Spawns/PlayerSpawnT"
@onready var player_spawn_r : Marker2D = $"Player Spawns/PlayerSpawnR"
@onready var player_spawn_d : Marker2D = $"Player Spawns/PlayerSpawnD"
@onready var player_spawn_l : Marker2D = $"Player Spawns/PlayerSpawnL"
@onready var doors : Node2D = $Doors

var discovered : bool = false

# Doors
var door_up : bool = false
var door_left : bool = false
var door_down : bool = false
var door_right : bool = false


func _enter_room(dir_from : String) -> void:
	var player = RunManager.player
	if not discovered:
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
		
		lock_doors()
		load_enemies(dir_from)
		discovered = true
		
	else:
		spawn_open_doors()



func load_enemies(player_spawn : String) -> void:
	pass


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
