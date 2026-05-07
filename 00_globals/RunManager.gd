# Run Manager
extends Node

var player : Player
var current_room : Vector2i = Vector2i(0, 0)
var current_room_instance : Node = null

var is_transitioning : bool = false
var can_trigger_doors : bool = false

@export var room_parent : Node   # Assign this in your main scene

var ROOM_SCENES = {
	"URDL": preload("res://scenes/Rooms/URDL_Rooms/room_urdl_empty.tscn"),
	"URD": preload("res://scenes/Rooms/URD_Rooms/room_urd_empty.tscn"),
	"RDL": preload("res://scenes/Rooms/RDL_Rooms/room_rdl_empty.tscn"),
	"UDL": preload("res://scenes/Rooms/UDL_Rooms/room_udl_empty.tscn"),
	"URL": preload("res://scenes/Rooms/URL_Rooms/room_url_empty.tscn"),
	"UR": preload("res://scenes/Rooms/UR_Rooms/room_ur_empty.tscn"),
	"UD": preload("res://scenes/Rooms/UD_Rooms/room_ud_empty.tscn"),
	"UL": preload("res://scenes/Rooms/UL_Rooms/room_ul_empty.tscn"),
	"RD": preload("res://scenes/Rooms/RD_Rooms/room_rd_empty.tscn"),
	"RL": preload("res://scenes/Rooms/RL_Rooms/room_rl_empty.tscn"),
	"DL": preload("res://scenes/Rooms/DL_Rooms/room_dl_empty.tscn"),
	"U": preload("res://scenes/Rooms/U_Rooms/room_u_empty.tscn"),
	"R": preload("res://scenes/Rooms/R_Rooms/room_r_empty.tscn"),
	"D": preload("res://scenes/Rooms/D_Rooms/room_d_empty.tscn"),
	"L": preload("res://scenes/Rooms/L_Rooms/room_l_empty.tscn")
}


func start_new_run(_player : Player):
	
	MapGenerationManager.create_new_map()
	current_room = MapGenerationManager._start
	
	print("Starting room: ", current_room)
	
	if _player == null:
		player = preload("res://player/Player.tscn").instantiate()
	else:
		player = _player
	
	load_room(current_room, "C")


func load_room(pos: Vector2i, entry_dir: String):
	
	# Remove old room
	if current_room_instance:
		current_room_instance.queue_free()
	
	# Get room layout code
	var code = MapGenerationManager.get_room_code(pos)
	
	if code == "":
		push_error("Room has no connections at: " + str(pos))
		return
	
	if not ROOM_SCENES.has(code):
		push_error("Missing room scene for code: " + code)
		return
	
	# Instantiate room
	var scene = ROOM_SCENES[code]
	var room = scene.instantiate()
	
	
	current_room_instance = room
	room_parent.add_child(room)
	
	# Update current position
	current_room = pos
	
	if str(MapGenerationManager.dungeon[pos.x][pos.y]) == "S":
		current_room_instance.set_floor("Start")
	
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
	print(new_pos)
	
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
	
	MapGenerationManager.room_states[pos]["cleared"] = true
