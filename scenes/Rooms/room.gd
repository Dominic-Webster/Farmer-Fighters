extends Node2D
class_name Room

@onready var art : Sprite2D = $Floor
@onready var player_spawn_c : Marker2D = $"Player Spawns/PlayerSpawnC"
@onready var player_spawn_t : Marker2D = $"Player Spawns/PlayerSpawnT"
@onready var player_spawn_r : Marker2D = $"Player Spawns/PlayerSpawnR"
@onready var player_spawn_d : Marker2D = $"Player Spawns/PlayerSpawnD"
@onready var player_spawn_l : Marker2D = $"Player Spawns/PlayerSpawnL"
@onready var doors : Node2D = $Doors
@onready var spawn_pools : Node2D = $SpawnPools
@onready var bullet_bounds : Node2D = $BulletBounds

var heart_scene : PackedScene = preload("res://PickUps/Heart/Heart.tscn")
const PICKUP_SPAWN_OFFSET := Vector2(0, -48)

var enemy_count : int = 0
var _room_persistent_spawn_ids := {
	"combat_reward": "combat_reward",
	"treasure": "treasure",
	"miniboss_reward": "miniboss_reward",
	"boss_heart": "boss_heart",
}


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
	
	# Respawn all persistent room objects that were previously registered.
	spawn_persistent_objects(pos)

	# Respawn elevator if present in this room (e.g. boss room after defeat)
	if MapGenerationManager.room_states.has(pos):
		var state = MapGenerationManager.room_states[pos]
		if state.has("elevator_present") and state["elevator_present"]:
			var ElevatorScene = preload("res://scenes/Elevator/Elevator.tscn")
			var elevator = ElevatorScene.instantiate()
			elevator.global_position = state["elevator_position"]
			add_child(elevator)
			elevator.visible = true
			elevator.open()

	if MapGenerationManager.room_states.has(pos) and MapGenerationManager.room_states[pos].get("cleared", false):
		spawn_open_doors()
	else:
		if MapGenerationManager.dungeon[pos.x][pos.y] == "T":
			spawn_room_treasure(pos)
			spawn_open_doors()
		elif MapGenerationManager.dungeon[pos.x][pos.y] == "M":
			load_miniboss(dir_from)
			if enemy_count == 0:
				spawn_open_doors()
			else:
				lock_doors()
		elif MapGenerationManager.dungeon[pos.x][pos.y] == "B":
			load_boss(dir_from)
			lock_doors()
		else:
			load_enemies(dir_from)
			if enemy_count == 0:
				spawn_open_doors()
			else:
				lock_doors()
	
	spawn_companions()


#func _input(_event: InputEvent) -> void:
	#if Input.is_action_pressed("opendoor"):
		#unlock_doors()


func spawn_companions() -> void:
	var player = RunManager.player
	
	if player.cow_unlocked:
		var cow = preload("res://Companions/Cow/Cow.tscn").instantiate()
		add_child(cow)
		cow.global_position = player.global_position
	if player.chicken_unlocked:
		var chicken = preload("res://Companions/Chicken/Chicken.tscn").instantiate()
		add_child(chicken)
		chicken.global_position = player.global_position
		if player.global_position == player_spawn_d.global_position or player.global_position == player_spawn_t.global_position:
			chicken.global_position.x += 50


func load_enemies(_player_spawn : String) -> void:
	if (MapGenerationManager.dungeon[RunManager.current_room.x][RunManager.current_room.y] == "S" or
		MapGenerationManager.dungeon[RunManager.current_room.x][RunManager.current_room.y] == "B" or
		MapGenerationManager.dungeon[RunManager.current_room.x][RunManager.current_room.y] == "T" or
		MapGenerationManager.dungeon[RunManager.current_room.x][RunManager.current_room.y] == "M"):
			return
	
	var enemy_limit = RunManager.rng.randi_range(1, 4)
	if RunManager.current_floor > 3:
		enemy_limit += 1
	
	var enemy_pool = get_enemy_pool()
	
	if enemy_pool == []:
		print("No Enemy Pool")
		return
	
	var spawn_points = get_spawn_points(_player_spawn)
	for spawn in spawn_points:
		if RunManager.rng.randi_range(1, 3) == 1 and enemy_count < enemy_limit:
			var scene_path = enemy_pool[RunManager.rng.randi() % enemy_pool.size()]
			var scene = load(scene_path)
			var enemy = scene.instantiate()
			enemy.global_position = spawn.global_position
			if enemy_count + enemy.weight <= enemy_limit:
				add_child(enemy)
				enemy_count += enemy.weight
				enemy.died.connect(func(): _on_enemy_died(enemy))
	
	# load one enemy just in case
	if enemy_count == 0 and spawn_points.size() > 0:
		var scene_path = enemy_pool[RunManager.rng.randi() % enemy_pool.size()]
		var scene = load(scene_path)
		var enemy = scene.instantiate()
		enemy.global_position = spawn_points[0].global_position
		add_child(enemy)
		enemy_count += enemy.weight
		enemy.died.connect(func(): _on_enemy_died(enemy))


func spawn_explosion_effect(explosion: Node) -> void:
	add_child(explosion)


func add_persistent_spawn(spawn_id: String, scene_path: String, pos: Vector2, picked_up: bool = false) -> void:
	var room_pos = RunManager.current_room
	
	if !MapGenerationManager.room_states.has(room_pos):
		MapGenerationManager.room_states[room_pos] = {}
	
	var state = MapGenerationManager.room_states[room_pos]
	
	if !state.has("persistent_spawns"):
		state["persistent_spawns"] = []

	var persistent_spawns: Array = state["persistent_spawns"]
	var existing_index := -1
	for i in range(persistent_spawns.size()):
		if persistent_spawns[i].get("id", "") == spawn_id:
			existing_index = i
			break

	var spawn_data := {
		"id": spawn_id,
		"scene": scene_path,
		"position": pos,
		"picked_up": picked_up,
	}

	if existing_index >= 0:
		spawn_data["picked_up"] = persistent_spawns[existing_index].get("picked_up", false) or picked_up
		persistent_spawns[existing_index] = spawn_data
	else:
		persistent_spawns.append(spawn_data)
	
	MapGenerationManager.room_states[room_pos] = state


func spawn_persistent_objects(pos: Vector2i) -> void:
	var state = MapGenerationManager.room_states.get(pos, {})
	var persistent_spawns: Array = state.get("persistent_spawns", [])

	for spawn_data in persistent_spawns:
		spawn_persistent_object(pos, spawn_data)


func spawn_persistent_spawn(pos: Vector2i, spawn_id: String) -> void:
	var state = MapGenerationManager.room_states.get(pos, {})
	var persistent_spawns: Array = state.get("persistent_spawns", [])

	for spawn_data in persistent_spawns:
		if spawn_data.get("id", "") == spawn_id:
			spawn_persistent_object(pos, spawn_data)
			return


func spawn_persistent_object(pos: Vector2i, spawn_data: Dictionary) -> void:
	if spawn_data.get("picked_up", false):
		return

	var scene_path := str(spawn_data.get("scene", ""))
	if scene_path == "":
		return

	var scene = load(scene_path)
	if scene == null:
		return

	var instance = scene.instantiate()
	var spawn_position = spawn_data.get("position", player_spawn_c.global_position)
	instance.global_position = spawn_position + PICKUP_SPAWN_OFFSET
	call_deferred("add_child", instance)

	if instance.has_signal("picked_up") and spawn_data.has("id"):
		var spawn_id := str(spawn_data["id"])
		instance.picked_up.connect(func(iname, desc):
			mark_persistent_spawn_picked_up(pos, spawn_id)
			if RunManager.gui:
				RunManager.gui.show_item_info(iname, desc)
		)


func mark_persistent_spawn_picked_up(pos: Vector2i, spawn_id: String) -> void:
	var state = MapGenerationManager.room_states.get(pos, {})
	var persistent_spawns: Array = state.get("persistent_spawns", [])

	for i in range(persistent_spawns.size()):
		if persistent_spawns[i].get("id", "") == spawn_id:
			persistent_spawns[i]["picked_up"] = true
			state["persistent_spawns"] = persistent_spawns
			MapGenerationManager.room_states[pos] = state
			return


# Helper to get the enemy pool for the current floor (for now, always floor1)
func get_enemy_pool() -> Array:
	var file = FileAccess.open("res://Data/enemy_pool.json", FileAccess.READ)
	if not file:
		return []
	var data = JSON.parse_string(file.get_as_text())
	
	var current_floor = str(RunManager.current_floor)
	
	if typeof(data) != TYPE_DICTIONARY or not data.has(current_floor):
		return []
	
	return data[current_floor]


func load_boss(_player_spawn : String) -> void:
	var boss_pool = get_boss_pool()
	
	if boss_pool == []:
		print("No Enemy Pool")
		return
	
	var spawn_points = get_spawn_points(_player_spawn)
	if spawn_points.is_empty():
		spawn_points = [player_spawn_c]
	var spawn = RunManager.rng.randi_range(0, spawn_points.size() - 1)
	var scene_path = boss_pool[RunManager.rng.randi() % boss_pool.size()]
	var scene = load(scene_path)
	var boss = scene.instantiate()
	boss.global_position = spawn_points[spawn].global_position
	add_child(boss)
	enemy_count += 1
	boss.died.connect(func(): _on_enemy_died(boss))


func load_miniboss(_player_spawn : String) -> void:
	var miniboss_pool = get_miniboss_pool()

	if miniboss_pool == []:
		print("No Miniboss Pool")
		return

	var scene_path = miniboss_pool[RunManager.rng.randi() % miniboss_pool.size()]
	var scene = load(scene_path)
	var miniboss = scene.instantiate()
	miniboss.global_position = player_spawn_c.global_position
	add_child(miniboss)
	enemy_count += 1
	miniboss.died.connect(func(): _on_enemy_died(miniboss))

	


func get_boss_pool() -> Array:
	var file = FileAccess.open("res://Data/boss_pool.json", FileAccess.READ)
	if not file:
		return []
	var data = JSON.parse_string(file.get_as_text())
	
	var current_floor = str(RunManager.current_floor)
	
	if typeof(data) != TYPE_DICTIONARY or not data.has(current_floor):
		return []
	return data[current_floor]

func get_miniboss_pool() -> Array:
	var file = FileAccess.open("res://Data/miniboss_pool.json", FileAccess.READ)
	if not file:
		return []
	var data = JSON.parse_string(file.get_as_text())

	var current_floor = str(RunManager.current_floor)

	if typeof(data) != TYPE_DICTIONARY or not data.has(current_floor):
		return []
	return data[current_floor]


func _on_enemy_died(enemy : Enemy):
	enemy_count -= enemy.weight
	
	if enemy_count == 0:
		RunManager.mark_room_cleared()
		unlock_doors()
		if MapGenerationManager.dungeon[RunManager.current_room.x][RunManager.current_room.y] == "M":
			spawn_miniboss_reward(RunManager.current_room)
	
		# Persistent pickup logic
		if MapGenerationManager.dungeon[RunManager.current_room.x][RunManager.current_room.y] != "B" and MapGenerationManager.dungeon[RunManager.current_room.x][RunManager.current_room.y] != "M":
			var pos = RunManager.current_room
			var player = RunManager.player
			var luck : int = 1
			if player != null and "luck" in player:
				luck = player.luck
			var roll = RunManager.rng.randi_range(1, 25)
			if roll <= luck:
				var pickup_scene = get_random_pickup_scene()
				if pickup_scene:
					add_persistent_spawn(_room_persistent_spawn_ids["combat_reward"], pickup_scene.resource_path, player_spawn_c.global_position)
					spawn_room_pickup(pos)


# Spawns a persistent pickup for the room if it exists and is not picked up
func spawn_room_pickup(pos: Vector2i) -> void:
	spawn_persistent_spawn(pos, _room_persistent_spawn_ids["combat_reward"])


func spawn_room_miniboss_reward(pos: Vector2i) -> void:
	spawn_persistent_spawn(pos, _room_persistent_spawn_ids["miniboss_reward"])


func spawn_room_heart(pos: Vector2i) -> void:
	spawn_persistent_spawn(pos, _room_persistent_spawn_ids["boss_heart"])


func spawn_heart() -> void:
	var pos = RunManager.current_room
	add_persistent_spawn(_room_persistent_spawn_ids["boss_heart"], heart_scene.resource_path, player_spawn_c.global_position)
	spawn_room_heart(pos)


func spawn_miniboss_reward(pos: Vector2i) -> void:
	var reward_item_path = get_miniboss_reward_item_scene()
	if reward_item_path == "":
		return
	add_persistent_spawn(_room_persistent_spawn_ids["miniboss_reward"], reward_item_path, player_spawn_c.global_position)

	spawn_room_miniboss_reward(pos)


func get_miniboss_reward_item_scene() -> String:
	var file = FileAccess.open("res://Data/miniboss_reward_pool.json", FileAccess.READ)
	if not file:
		return ""

	var data = JSON.parse_string(file.get_as_text())
	if typeof(data) != TYPE_DICTIONARY:
		return ""

	var current_floor = str(RunManager.current_floor)
	if not data.has(current_floor):
		return ""

	var pool = data[current_floor]
	if pool.size() == 0:
		return ""

	return pool[RunManager.rng.randi() % pool.size()]


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
	var item_path = pool[RunManager.rng.randi() % pool.size()]
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
		art.texture = load("res://scenes/Rooms/00_sprites/start_room.png")
	elif desc == "Item":
		art.texture = load("res://scenes/Rooms/00_sprites/item_room.png")


func _set_door_art() -> void:
	var x_pos : int = RunManager.current_room.x
	var y_pos : int = RunManager.current_room.y
	
	# Up
	if doors.has_node("DoorUp"):
		if y_pos > 0:
			if str(MapGenerationManager.dungeon[x_pos][y_pos - 1]) == "B":
				$Doors/DoorUp.set_door_art("B")
			if str(MapGenerationManager.dungeon[x_pos][y_pos - 1]) == "M":
				$Doors/DoorUp.set_door_art("M")
			if str(MapGenerationManager.dungeon[x_pos][y_pos - 1]) == "T":
				$Doors/DoorUp.set_door_art("T")
	
	# Right
	if doors.has_node("DoorRight"):
		if x_pos < (MapGenerationManager._dimensons.x - 1):
			if str(MapGenerationManager.dungeon[x_pos + 1][y_pos]) == "B":
				$Doors/DoorRight.set_door_art("B")
			if str(MapGenerationManager.dungeon[x_pos + 1][y_pos]) == "M":
				$Doors/DoorRight.set_door_art("M")
			if str(MapGenerationManager.dungeon[x_pos + 1][y_pos]) == "T":
				$Doors/DoorRight.set_door_art("T")
	
	# Down
	if doors.has_node("DoorDown"):
		if y_pos < (MapGenerationManager._dimensons.y - 1):
			if str(MapGenerationManager.dungeon[x_pos][y_pos + 1]) == "B":
				$Doors/DoorDown.set_door_art("B")
			if str(MapGenerationManager.dungeon[x_pos][y_pos + 1]) == "M":
				$Doors/DoorDown.set_door_art("M")
			if str(MapGenerationManager.dungeon[x_pos][y_pos + 1]) == "T":
				$Doors/DoorDown.set_door_art("T")
	
	# Left
	if doors.has_node("DoorLeft"):
		if x_pos > 0:
			if str(MapGenerationManager.dungeon[x_pos - 1][y_pos]) == "B":
				$Doors/DoorLeft.set_door_art("B")
			if str(MapGenerationManager.dungeon[x_pos - 1][y_pos]) == "M":
				$Doors/DoorLeft.set_door_art("M")
			if str(MapGenerationManager.dungeon[x_pos - 1][y_pos]) == "T":
				$Doors/DoorLeft.set_door_art("T")


func _load_bullet_bounds() -> void:
	if bullet_bounds:
		for child in bullet_bounds.get_children():
			child.add_to_group("bullet_bounds")



# Spawns the treasure item for this room, tracking persistence and pickup
func spawn_room_treasure(pos: Vector2i) -> void:
	var state = MapGenerationManager.room_states.get(pos, {})

	if state.has("persistent_spawns"):
		for spawn_data in state["persistent_spawns"]:
			if spawn_data.get("id", "") == _room_persistent_spawn_ids["treasure"]:
				return

	var item_scene = get_random_item_scene()
	if item_scene == null:
		return

	add_persistent_spawn(_room_persistent_spawn_ids["treasure"], item_scene.resource_path, player_spawn_c.global_position)
	spawn_persistent_spawn(pos, _room_persistent_spawn_ids["treasure"])


func get_random_item_scene():
	if RunManager.rng.randi_range(1, 30) + RunManager.player.luck < 25:
		var common_item_path = ItemManager.get_random_item("common")
		if common_item_path != "":
			return load(common_item_path)
	else:
		var uncommon_item_path = ItemManager.get_random_item("uncommon")
		if uncommon_item_path != "":
			return load(uncommon_item_path)

	return null


# Returns the spawn points for the given entry direction ("U", "R", "D", "L")
func get_spawn_points(entry_dir: String) -> Array:
	if entry_dir == "C":
		return [player_spawn_c]

	var pool_name = "SpawnPool_"
	match entry_dir:
		"U": pool_name += "Up"
		"R": pool_name += "Right"
		"D": pool_name += "Down"
		"L": pool_name += "Left"
		_: return []
	if spawn_pools.has_node(pool_name):
		return spawn_pools.get_node(pool_name).get_children()
	return [player_spawn_c]


func spawn_elevator_at_center():
	# Spawn elevator at center of viewport, save state for persistence
	var ElevatorScene = preload("res://scenes/Elevator/Elevator.tscn")
	var elevator = ElevatorScene.instantiate()
	add_child(elevator)
	var viewport = get_viewport()
	var center = viewport.get_visible_rect().size / 2
	elevator.global_position = center
	elevator.load_in()
	var pos = RunManager.current_room
	var state = MapGenerationManager.room_states.get(pos, {})
	state["elevator_present"] = true
	state["elevator_position"] = elevator.global_position
	MapGenerationManager.room_states[pos] = state
	await get_tree().process_frame # Ensure elevator is in scene tree
	await elevator.lower()


func spawn_random_item(spawn_position: Vector2) -> void:
	var scene_path = ""
	var roll = RunManager.rng.randi() % 75
	if roll < RunManager.player.luck:
		scene_path = ItemManager.get_random_item("rare")
	else:
		roll = RunManager.rng.randi() % 50
		if roll < RunManager.player.luck:
			scene_path = ItemManager.get_random_item("uncommon")
		else:
			scene_path = ItemManager.get_random_item("common")

	# Fallback to default pool if all pools are empty
	if scene_path == "":
		scene_path = ItemManager.get_default_item()

	if scene_path != "":
		var item_scene = load(scene_path)
		var item_instance = item_scene.instantiate()
		add_child(item_instance)
		item_instance.global_position = spawn_position + PICKUP_SPAWN_OFFSET


# Frees all enemy bullets in the scene
func free_all_enemy_bullets():
	for bullet in get_tree().get_nodes_in_group("enemy_bullet"):
		bullet.queue_free()
	for bullet in get_tree().get_nodes_in_group("comp_bullet"):
		bullet.queue_free()
