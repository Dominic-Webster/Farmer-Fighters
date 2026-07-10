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
	spawn_room_miniboss_reward(pos)

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


#func _input(_event: InputEvent) -> void:
	#if Input.is_action_pressed("opendoor"):
		#unlock_doors()


func load_enemies(_player_spawn : String) -> void:
	if (MapGenerationManager.dungeon[RunManager.current_room.x][RunManager.current_room.y] == "S" or
		MapGenerationManager.dungeon[RunManager.current_room.x][RunManager.current_room.y] == "B" or
		MapGenerationManager.dungeon[RunManager.current_room.x][RunManager.current_room.y] == "T" or
		MapGenerationManager.dungeon[RunManager.current_room.x][RunManager.current_room.y] == "M"):
			return
	
	var enemy_limit = randi_range(1, 4)
	
	var enemy_pool = get_enemy_pool()
	
	if enemy_pool == []:
		print("No Enemy Pool")
		return
	
	var spawn_points = get_spawn_points(_player_spawn)
	for spawn in spawn_points:
		if randi_range(1, 3) == 1 and enemy_count < enemy_limit:
			var scene_path = enemy_pool[randi() % enemy_pool.size()]
			var scene = load(scene_path)
			var enemy = scene.instantiate()
			enemy.global_position = spawn.global_position
			add_child(enemy)
			enemy_count += 1
			enemy.died.connect(_on_enemy_died)
	
	# load one enemy just in case
	if enemy_count == 0 and spawn_points.size() > 0:
		var scene_path = enemy_pool[randi() % enemy_pool.size()]
		var scene = load(scene_path)
		var enemy = scene.instantiate()
		enemy.global_position = spawn_points[0].global_position
		add_child(enemy)
		enemy_count += 1
		enemy.died.connect(_on_enemy_died)


func spawn_explosion_effect(explosion: Node) -> void:
	add_child(explosion)


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
	var spawn = randi_range(0, spawn_points.size() - 1)
	var scene_path = boss_pool[randi() % boss_pool.size()]
	var scene = load(scene_path)
	var boss = scene.instantiate()
	boss.global_position = spawn_points[spawn].global_position
	add_child(boss)
	enemy_count += 1
	boss.died.connect(_on_enemy_died)

func load_miniboss(_player_spawn : String) -> void:
	var miniboss_pool = get_miniboss_pool()

	if miniboss_pool == []:
		print("No Miniboss Pool")
		return

	var scene_path = miniboss_pool[randi() % miniboss_pool.size()]
	var scene = load(scene_path)
	var miniboss = scene.instantiate()
	miniboss.global_position = player_spawn_c.global_position
	add_child(miniboss)
	enemy_count += 1
	miniboss.died.connect(_on_enemy_died)

	


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


func _on_enemy_died():
	enemy_count -= 1
	
	if enemy_count == 0:
		RunManager.mark_room_cleared()
		unlock_doors()
		if MapGenerationManager.dungeon[RunManager.current_room.x][RunManager.current_room.y] == "M":
			spawn_miniboss_reward(RunManager.current_room)
	
		# Persistent pickup logic
		if MapGenerationManager.dungeon[RunManager.current_room.x][RunManager.current_room.y] != "B":
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
				pickup.picked_up.connect(func(iname, desc):
					var s = MapGenerationManager.room_states.get(pos, {})
					s["pickup_picked_up"] = true
					MapGenerationManager.room_states[pos] = s
					if RunManager.gui:
						RunManager.gui.show_item_info(iname, desc)
				)


func spawn_room_miniboss_reward(pos: Vector2i) -> void:
	var state = MapGenerationManager.room_states.get(pos, {})

	if not state.has("miniboss_reward_item_path") or (state.has("miniboss_reward_picked_up") and state["miniboss_reward_picked_up"]):
		return

	var reward_scene = load(state["miniboss_reward_item_path"])
	if reward_scene:
		var reward = reward_scene.instantiate()
		reward.global_position = player_spawn_c.global_position
		call_deferred("add_child", reward)
		if reward.has_signal("picked_up"):
			reward.picked_up.connect(func(iname, desc):
				var s = MapGenerationManager.room_states.get(pos, {})
				s["miniboss_reward_picked_up"] = true
				MapGenerationManager.room_states[pos] = s
				if RunManager.gui:
					RunManager.gui.show_item_info(iname, desc)
			)


func spawn_miniboss_reward(pos: Vector2i) -> void:
	var state = MapGenerationManager.room_states.get(pos, {})

	if not state.has("miniboss_reward_item_path"):
		var reward_item_path = get_miniboss_reward_item_scene()
		if reward_item_path == "":
			return
		state["miniboss_reward_item_path"] = reward_item_path
		state["miniboss_reward_picked_up"] = false
		MapGenerationManager.room_states[pos] = state

	if state.has("miniboss_reward_picked_up") and state["miniboss_reward_picked_up"]:
		return

	var reward_scene = load(state["miniboss_reward_item_path"])
	if reward_scene:
		var reward = reward_scene.instantiate()
		reward.global_position = player_spawn_c.global_position
		call_deferred("add_child", reward)
		if reward.has_signal("picked_up"):
			reward.picked_up.connect(func(iname, desc):
				var s = MapGenerationManager.room_states.get(pos, {})
				s["miniboss_reward_picked_up"] = true
				MapGenerationManager.room_states[pos] = s
				if RunManager.gui:
					RunManager.gui.show_item_info(iname, desc)
			)


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

	return pool[randi() % pool.size()]


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
	
	# Connect picked_up signal to mark as picked up and show HUD info
	if item.has_signal("picked_up"):
		item.picked_up.connect(func(iname, desc):
			var s = MapGenerationManager.room_states.get(pos, {})
			s["treasure_picked_up"] = true
			MapGenerationManager.room_states[pos] = s
			if RunManager.gui:
				RunManager.gui.show_item_info(iname, desc)
			)


func get_random_item_scene():
	var file = FileAccess.open("res://Data/item_pool.json", FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	var pool
	if randi_range(1, 30) + RunManager.player.luck < 25:
		pool = data["common"]
	else:
		pool = data["uncommon"]
	var item_path = pool[randi() % pool.size()]
	return load(item_path)


# Returns the spawn points for the given entry direction ("U", "R", "D", "L")
func get_spawn_points(entry_dir: String) -> Array:
	var pool_name = "SpawnPool_"
	match entry_dir:
		"U": pool_name += "Up"
		"R": pool_name += "Right"
		"D": pool_name += "Down"
		"L": pool_name += "Left"
		_: return []
	if spawn_pools.has_node(pool_name):
		return spawn_pools.get_node(pool_name).get_children()
	return []


func spawn_elevator_at_center():
	# Spawn elevator at center of viewport, save state for persistence
	var ElevatorScene = preload("res://scenes/Elevator/Elevator.tscn")
	var elevator = ElevatorScene.instantiate()
	add_child(elevator)
	var viewport = get_viewport()
	var center = viewport.get_visible_rect().size / 2
	elevator.global_position = center
	elevator.load_in()
	await get_tree().process_frame # Ensure elevator is in scene tree
	await elevator.lower()
	# Save elevator state for persistence
	var pos = RunManager.current_room
	var state = MapGenerationManager.room_states.get(pos, {})
	state["elevator_present"] = true
	state["elevator_position"] = elevator.global_position
	MapGenerationManager.room_states[pos] = state


func spawn_random_item(spawn_position: Vector2) -> void:
	var scene_path = ""
	var rng = randi() % 75
	if rng < RunManager.player.luck:
		scene_path = ItemManager.get_random_item("rare")
	else:
		rng = randi() % 50
		if rng < RunManager.player.luck:
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
		item_instance.global_position = spawn_position


# Frees all enemy bullets in the scene
func free_all_enemy_bullets():
	for bullet in get_tree().get_nodes_in_group("enemy_bullet"):
		bullet.queue_free()
