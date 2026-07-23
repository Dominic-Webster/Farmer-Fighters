# Run Manager
extends Node

var difficulty : String

@warning_ignore("unused_signal")
signal ended

var run_seed : int = 0
var rng : RandomNumberGenerator = RandomNumberGenerator.new()


@export var room_parent : Node   # Assign this in your main scene

# Stores which scene was chosen for each room position
var room_history := {}
const RoomOptions = preload("res://scenes/Rooms/RoomOptions.gd")

var player_data : PlayerData

var player : Player
var gui : PlayerHud = null
var current_room : Vector2i = Vector2i(0, 0)
var current_entry_dir : String = "C"
var current_room_instance : Node = null
var pending_run_data : Dictionary = {}

var is_transitioning : bool = false
var can_trigger_doors : bool = false

var current_floor : int = 1

var player_damaged_this_floor : bool = false


# Testing
var test_item_1 = "res://Items/Common/Broccoli/Broccoli.tscn"
var test_item_2 = "res://Items/Common/Eggplant/Eggplant.tscn"
var test_item_3 = "res://Items/Unlocks/Tomatillo/Tomatillo.tscn"
var test_item_4 = "res://Items/Common/Salsa/Salsa.tscn"
var test_item_5 = "res://Items/Common/Honeynut_Squash/Honeynut_Squash.tscn"
var test_item_6 = "res://Items/Uncommon/Zucchini/Zucchini.tscn"


func start_new_run(_player : Player):
	pending_run_data.clear()
	
	current_floor = 1
	player_damaged_this_floor = false
	
	run_seed = int(Time.get_unix_time_from_system() * 1000000.0) ^ Time.get_ticks_usec()
	#run_seed = 12345
	rng.seed = run_seed
	print("Run seed: ", run_seed)
	
	MapGenerationManager.create_new_map()
	current_room = MapGenerationManager._start
	
	if _player == null:
		player = preload("res://player/Player.tscn").instantiate()
	else:
		player = _player
	
	load_room(current_room, "C")


func start_loaded_run(run_data: Dictionary) -> void:
	pending_run_data = run_data.duplicate(true)


func load_room(pos: Vector2i, entry_dir: String):
	current_entry_dir = entry_dir
	
	# Remove old room and free enemy bullets
	if current_room_instance:
		if current_room_instance.has_method("free_all_enemy_bullets"):
			current_room_instance.free_all_enemy_bullets()
		current_room_instance.queue_free()

	# Get room layout code (lowercase for consistency)
	var code = MapGenerationManager.get_room_code(pos).to_lower()
	if code == "":
		push_error("Room has no connections at: " + str(pos))
		return

	# Determine room type
	var room_type = "normal"
	if str(MapGenerationManager.dungeon[pos.x][pos.y]) == "S":
		room_type = "start"
	elif str(MapGenerationManager.dungeon[pos.x][pos.y]) == "T":
		room_type = "item"
	elif str(MapGenerationManager.dungeon[pos.x][pos.y]) == "B":
		room_type = "boss"
	elif str(MapGenerationManager.dungeon[pos.x][pos.y]) == "M":
		room_type = "miniboss"

	# Get room options for current floor, code, and type
	var options = RoomOptions.get_options(current_floor, code, room_type)
	if options.size() == 0:
		# fallback to normal if special type missing
		options = RoomOptions.get_options(current_floor, code, "normal")
		if options.size() == 0:
			push_error("No room options for code: " + code + " on floor: " + str(current_floor) + " (type: " + room_type + ")")
			return

	# Use stored variant if available, otherwise pick and store
	var pos_key = str(pos)
	var scene_path = ""
	if room_history.has(pos_key):
		scene_path = room_history[pos_key]
	else:
		scene_path = options[rng.randi() % options.size()]
		room_history[pos_key] = scene_path
	var scene = load(scene_path)
	var room = scene.instantiate()

	current_room_instance = room
	room_parent.add_child(room)

	# Update current position
	current_room = pos

	# Enter room (handles player spawn)
	room._enter_room(entry_dir)

	# Small delay before allowing another transition
	can_trigger_doors = false

	await get_tree().process_frame  # let physics settle
	await get_tree().process_frame  # extra safety

	can_trigger_doors = true
	is_transitioning = false


func change_room(direction: String):
	if is_transitioning:
		return
	
	is_transitioning = true
	
	var offset := Vector2i.ZERO
	
	match direction:
		"U":
			offset = Vector2i(0, -1)
		"R":
			offset = Vector2i(1, 0)
		"D":
			offset = Vector2i(0, 1)
		"L":
			offset = Vector2i(-1, 0)
	
	var new_pos = current_room + offset
	#print(new_pos)
	
	# Safety check
	if not MapGenerationManager._has_room(new_pos):
		print("No room at: ", new_pos)
		return
	
	load_room(new_pos, _get_opposite_dir(direction))


func _get_opposite_dir(dir: String) -> String:
	match dir:
		"U": return "D"
		"D": return "U"
		"L": return "R"
		"R": return "L"
	return "C"


func mark_room_cleared() -> void:
	var pos = current_room
	
	if not MapGenerationManager.room_states.has(pos):
		MapGenerationManager.room_states[pos] = {}
	
	MapGenerationManager.room_states[pos] = {
		"cleared": true,
		"visited": true,
		"type": "combat"
	}

#var heart_scene : PackedScene = preload("res://PickUps/Heart/Heart.tscn")
#func spawn_heart() -> void:
	#var room := current_room_instance as Room
	#if room == null:
		#return
#
	#var item_scene = heart_scene
	#if item_scene == null:
		#return
#
	#var item_instance = item_scene.instantiate()
	#room.add_child(item_instance)
	#item_instance.global_position = room.player_spawn_c.global_position


# --------------
# DEV OPTIONS
# --------------

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("view_stats"):
		print_stats()
		#if MetaManager != null:
			#MetaManager.reset_progress_to_base()
			#print("META RESET")
	#else:
		#load_item(event)


func load_item(event: InputEvent) -> void:
	var scene_path := ""

	if event.is_action_pressed("test_item_1"):
		scene_path = test_item_1
		#player.inverse_controls = !player.inverse_controls
		#player.dash_unlocked = !player.dash_unlocked
	elif event.is_action_pressed("test_item_2"):
		scene_path = test_item_2
	elif event.is_action_pressed("test_item_3"):
		scene_path = test_item_3
	elif event.is_action_pressed("test_item_4"):
		scene_path = test_item_4
	elif event.is_action_pressed("test_item_5"):
		scene_path = test_item_5
	elif event.is_action_pressed("test_item_6"):
		scene_path = test_item_6

	if scene_path == "":
		return

	var room := current_room_instance as Room
	if room == null:
		return

	var item_scene = load(scene_path)
	if item_scene == null:
		return

	var item_instance = item_scene.instantiate()
	room.add_child(item_instance)
	item_instance.global_position = room.player_spawn_c.global_position


func print_stats() -> void:
	print("----------")
	print("Player Stats")
	print("Health: ", player.current_health, "/", player.get_max_health())
	print("Damage: ", player.damage)
	print("Damage Mult: ", player.damage_mult)
	print("Calculated Total Damage: ", player.damage * player.damage_mult)
	print("Luck: ", player.luck)
	print("Move Speed: ", player.move_speed)
	print("Accuracy: ", player.accuracy)
	print("Fire Rate: ", player.fire_rate)
	print("Bullet Speed: ", player.bullet_speed)
	print("----------")
