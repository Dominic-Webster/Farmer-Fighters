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
@onready var bullet_bounds : Node2D = $BulletBounds

var enemy_scenes : Array[PackedScene] = [
	load("res://Enemies/Chips/Chips.tscn"),
	load("res://Enemies/Soda/Soda.tscn")
]

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
	
	var pos = RunManager.current_room
	
	_set_door_art()
	
	_load_bullet_bounds()
	
	if MapGenerationManager.room_states.has(pos) and MapGenerationManager.room_states[pos].get("cleared", false):
		spawn_open_doors()
	else:
		load_enemies(dir_from)
		if enemy_count == 0:
			spawn_open_doors()
		else:
			lock_doors()


#func _input(_event: InputEvent) -> void:
	#if Input.is_action_pressed("opendoor"):
		#unlock_doors()


func load_enemies(_player_spawn : String) -> void:
	if (MapGenerationManager.dungeon[RunManager.current_room.x][RunManager.current_room.y] == "S" or
		MapGenerationManager.dungeon[RunManager.current_room.x][RunManager.current_room.y] == "B" or
		MapGenerationManager.dungeon[RunManager.current_room.x][RunManager.current_room.y] == "T"):
			return
	
	var spawns : Array[int] = get_enemy_spawns(_player_spawn)
	var counter : int = 0
	
	for spawn in enemy_spawns.get_children():
		if counter in spawns:
			var scene = enemy_scenes.pick_random()
			var enemy = scene.instantiate()
			enemy.global_position = spawn.global_position
		
			add_child(enemy)
		
			enemy_count += 1
		
			enemy.died.connect(_on_enemy_died)
		counter += 1


func get_enemy_spawns(_player : String) -> Array[int]:
	var spawns : Array[int] = []
	var options : Array[int] = []
	var max_enemies : int = randi_range(1, 4)
	
	if _player == "C":
		options = [0, 1, 4, 5, 6, 11, 12, 17, 18, 19, 22, 23]
		for i in options:
			if randi_range(1, 3) == 1:
				spawns.append(i)
				if spawns.size() == max_enemies:
					break
	elif _player == "U":
		options = [12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23]
		for i in options:
			if randi_range(1, 3) == 1:
				spawns.append(i)
				if spawns.size() == max_enemies:
					break
	elif _player == "R":
		options = [0, 1, 2, 3, 6, 7, 8, 12, 13, 14, 18, 19, 20, 21]
		for i in options:
			if randi_range(1, 3) == 1:
				spawns.append(i)
				if spawns.size() == max_enemies:
					break
	elif _player == "D":
		options = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
		for i in options:
			if randi_range(1, 3) == 1:
				spawns.append(i)
				if spawns.size() == max_enemies:
					break
	elif _player == "L":
		options = [2, 3, 4, 5, 9, 10, 11, 15, 16, 17, 20, 21, 22, 23]
		for i in options:
			if randi_range(1, 3) == 1:
				spawns.append(i)
				if spawns.size() == max_enemies:
					break
	
	if spawns.size() == 0:
		spawns = [0]
	
	return spawns


func _on_enemy_died():
	enemy_count -= 1
	
	if enemy_count == 0:
		RunManager.mark_room_cleared()
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


func _set_door_art() -> void:
	var x_pos : int = RunManager.current_room.x
	var y_pos : int = RunManager.current_room.y
	
	# Up
	if doors.has_node("DoorUp"):
		if y_pos > 0:
			if str(MapGenerationManager.dungeon[x_pos][y_pos - 1]) == "B":
				$Doors/DoorUp.set_door_art("B")
			if str(MapGenerationManager.dungeon[x_pos][y_pos - 1]) == "T":
				$Doors/DoorUp.set_door_art("T")
	
	# Right
	if doors.has_node("DoorRight"):
		if x_pos < (MapGenerationManager._dimensons.x - 1):
			if str(MapGenerationManager.dungeon[x_pos + 1][y_pos]) == "B":
				$Doors/DoorRight.set_door_art("B")
			if str(MapGenerationManager.dungeon[x_pos + 1][y_pos]) == "T":
				$Doors/DoorRight.set_door_art("T")
	
	# Down
	if doors.has_node("DoorDown"):
		if y_pos < (MapGenerationManager._dimensons.y - 1):
			if str(MapGenerationManager.dungeon[x_pos][y_pos + 1]) == "B":
				$Doors/DoorDown.set_door_art("B")
			if str(MapGenerationManager.dungeon[x_pos][y_pos + 1]) == "T":
				$Doors/DoorDown.set_door_art("T")
	
	# Left
	if doors.has_node("DoorLeft"):
		if x_pos > 0:
			if str(MapGenerationManager.dungeon[x_pos - 1][y_pos]) == "B":
				$Doors/DoorLeft.set_door_art("B")
			if str(MapGenerationManager.dungeon[x_pos - 1][y_pos]) == "T":
				$Doors/DoorLeft.set_door_art("T")


func _load_bullet_bounds() -> void:
	if bullet_bounds:
		for child in bullet_bounds.get_children():
			child.add_to_group("bullet_bounds")
