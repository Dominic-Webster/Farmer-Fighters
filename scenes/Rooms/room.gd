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
	
	# Always respawn persistent pickup if present and not picked up
	spawn_room_pickup(pos)
	
	if MapGenerationManager.room_states.has(pos) and MapGenerationManager.room_states[pos].get("cleared", false):
		spawn_open_doors()
	else:
		if MapGenerationManager.dungeon[pos.x][pos.y] == "T":
			spawn_room_treasure(pos)
			spawn_open_doors()
		if MapGenerationManager.dungeon[pos.x][pos.y] == "B":
			load_boss(dir_from)
			lock_doors()
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
	
	var enemy_pool = get_enemy_pool()
	for spawn in enemy_spawns.get_children():
		if counter in spawns:
			var scene_path = enemy_pool[randi() % enemy_pool.size()]
			var scene = load(scene_path)
			var enemy = scene.instantiate()
			enemy.global_position = spawn.global_position
			add_child(enemy)
			enemy_count += 1
			enemy.died.connect(_on_enemy_died)
		counter += 1


# Helper to get the enemy pool for the current floor (for now, always floor1)
func get_enemy_pool() -> Array:
	var file = FileAccess.open("res://Data/enemy_pool.json", FileAccess.READ)
	if not file:
		return []
	var data = JSON.parse_string(file.get_as_text())
	if typeof(data) != TYPE_DICTIONARY or not data.has("floor1"):
		return []
	return data["floor1"]


func load_boss(_player_spawn : String) -> void:
	var boss_spawn : int = 16
	var counter : int = 0
	
	match _player_spawn:
		"C":
			boss_spawn = 16
		"U":
			boss_spawn = 16
		"R":
			boss_spawn = 13
		"D":
			boss_spawn = 7
		"L":
			boss_spawn = 16
	
	var boss_pool = get_boss_pool()
	for spawn in enemy_spawns.get_children():
		if counter == boss_spawn:
			var scene_path = boss_pool[randi() % boss_pool.size()]
			var scene = load(scene_path)
			var boss = scene.instantiate()
			boss.global_position = spawn.global_position
			add_child(boss)
			enemy_count += 1
			boss.died.connect(_on_enemy_died)
		counter += 1
	


func get_boss_pool() -> Array:
	var file = FileAccess.open("res://Data/boss_pool.json", FileAccess.READ)
	if not file:
		return []
	var data = JSON.parse_string(file.get_as_text())
	if typeof(data) != TYPE_DICTIONARY or not data.has("floor1"):
		return []
	return data["floor1"]


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
	
		# Persistent pickup logic
		var pos = RunManager.current_room
		var state = MapGenerationManager.room_states.get(pos, {})
		if not state.has("pickup_picked_up") or not state["pickup_picked_up"]:
			# Only roll if not already present
			if not state.has("pickup_item_path"):
				var player = RunManager.player
				var luck : int = 1
				if player != null and "luck" in player:
					luck = player.luck
				var roll = randi_range(1, 25)
				if roll <= luck:
					var pickup_scene = get_random_pickup_scene()
					if pickup_scene:
						state["pickup_item_path"] = pickup_scene.resource_path
						state["pickup_picked_up"] = false
						MapGenerationManager.room_states[pos] = state
						spawn_room_pickup(pos)


# Spawns a persistent pickup for the room if it exists and is not picked up
func spawn_room_pickup(pos: Vector2i) -> void:
	var state = MapGenerationManager.room_states.get(pos, {})
	if state.has("pickup_item_path") and (not state.has("pickup_picked_up") or not state["pickup_picked_up"]):
		var pickup_scene = load(state["pickup_item_path"])
		if pickup_scene:
			var pickup = pickup_scene.instantiate()
			pickup.global_position = player_spawn_c.global_position
			call_deferred("add_child", pickup)
			if pickup.has_signal("picked_up"):
				pickup.picked_up.connect(func():
					var s = MapGenerationManager.room_states.get(pos, {})
					s["pickup_picked_up"] = true
					MapGenerationManager.room_states[pos] = s
				)


# Helper to get a random pickup scene from pickup_pool.json
func get_random_pickup_scene():
	var file = FileAccess.open("res://Data/pickup_pool.json", FileAccess.READ)
	if not file:
		return null
	var data = JSON.parse_string(file.get_as_text())
	if typeof(data) != TYPE_DICTIONARY or not data.has("common"):
		return null
	var pool = data["common"]
	if pool.size() == 0:
		return null
	var item_path = pool[randi() % pool.size()]
	return load(item_path)


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
	elif desc == "Item":
		art.texture = load("res://scenes/Rooms/item_room.png")


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



# Spawns the treasure item for this room, tracking persistence and pickup
func spawn_room_treasure(pos: Vector2i) -> void:
	# Ensure room_states entry exists
	if not MapGenerationManager.room_states.has(pos):
		MapGenerationManager.room_states[pos] = {}
	
	var state = MapGenerationManager.room_states[pos]
	
	# If item was picked up, do not spawn
	if state.has("treasure_picked_up") and state["treasure_picked_up"]:
		return
	
	# If item_path not set, pick a random one and store it
	var item_scene
	if not state.has("treasure_item_path"):
		item_scene = get_random_item_scene()
		state["treasure_item_path"] = item_scene.resource_path
		MapGenerationManager.room_states[pos] = state
	else:
		item_scene = load(state["treasure_item_path"])
	
	# Instance and spawn the item
	var item = item_scene.instantiate()
	item.global_position = player_spawn_c.global_position
	add_child(item)
	
	# Connect picked_up signal to mark as picked up
	if item.has_signal("picked_up"):
		item.picked_up.connect(func():
			var s = MapGenerationManager.room_states.get(pos, {})
			s["treasure_picked_up"] = true
			MapGenerationManager.room_states[pos] = s
		)


func get_random_item_scene():
	var file = FileAccess.open("res://Data/item_pool.json", FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	var pool = data["common"]
	var item_path = pool[randi() % pool.size()]
	return load(item_path)
