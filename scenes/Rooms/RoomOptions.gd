extends Node


static var ROOM_OPTIONS = {
	1: {
		"urdl": {
			"normal": [
				"res://scenes/Rooms/URDL_Rooms/room_urdl_empty.tscn",
				"res://scenes/Rooms/URDL_Rooms/room_urdl_1.tscn",
				"res://scenes/Rooms/URDL_Rooms/room_urdl_2.tscn",
				"res://scenes/Rooms/URDL_Rooms/room_urdl_3.tscn"
				],
			"start": ["res://scenes/Rooms/URDL_Rooms/room_urdl_start.tscn"],
			"item": ["res://scenes/Rooms/URDL_Rooms/room_urdl_item.tscn"],
			"boss": [
				"res://scenes/Rooms/URDL_Rooms/room_urdl_empty.tscn",
				"res://scenes/Rooms/URDL_Rooms/room_urdl_2.tscn"
			]
		},
		"urd": {
			"normal": [
				"res://scenes/Rooms/URD_Rooms/room_urd_empty.tscn",
				"res://scenes/Rooms/URD_Rooms/room_urd_1.tscn",
				],
			"start": ["res://scenes/Rooms/URD_Rooms/room_urd_start.tscn"],
			"item": ["res://scenes/Rooms/URD_Rooms/room_urd_item.tscn"],
			"boss": [
				"res://scenes/Rooms/URD_Rooms/room_urd_empty.tscn",
				"res://scenes/Rooms/URD_Rooms/room_urd_1.tscn",
			]
		},
		"rdl": {
			"normal": [
				"res://scenes/Rooms/RDL_Rooms/room_rdl_empty.tscn",
				"res://scenes/Rooms/RDL_Rooms/room_rdl_1.tscn"
				],
			"start": ["res://scenes/Rooms/RDL_Rooms/room_rdl_start.tscn"],
			"item": ["res://scenes/Rooms/RDL_Rooms/room_rdl_item.tscn"],
			"boss": [
				"res://scenes/Rooms/RDL_Rooms/room_rdl_empty.tscn",
				"res://scenes/Rooms/RDL_Rooms/room_rdl_1.tscn"
			]
		},
		"udl": {
			"normal": [
				"res://scenes/Rooms/UDL_Rooms/room_udl_empty.tscn",
				"res://scenes/Rooms/UDL_Rooms/room_udl_1.tscn"
				],
			"start": ["res://scenes/Rooms/UDL_Rooms/room_udl_start.tscn"],
			"item": ["res://scenes/Rooms/UDL_Rooms/room_udl_item.tscn"],
			"boss": [
				"res://scenes/Rooms/UDL_Rooms/room_udl_empty.tscn",
				"res://scenes/Rooms/UDL_Rooms/room_udl_1.tscn"
				]
		},
		"url": {
			"normal": [
				"res://scenes/Rooms/URL_Rooms/room_url_empty.tscn",
				"res://scenes/Rooms/URL_Rooms/room_url_1.tscn"
				],
			"start": ["res://scenes/Rooms/URL_Rooms/room_url_start.tscn"],
			"item": ["res://scenes/Rooms/URL_Rooms/room_url_item.tscn"],
			"boss": [
				"res://scenes/Rooms/URL_Rooms/room_url_empty.tscn",
				"res://scenes/Rooms/URL_Rooms/room_url_1.tscn"
				]
		},
		"ur": {
			"normal": [
				"res://scenes/Rooms/UR_Rooms/room_ur_empty.tscn",
				"res://scenes/Rooms/UR_Rooms/room_ur_1.tscn"
				],
			"start": ["res://scenes/Rooms/UR_Rooms/room_ur_start.tscn"],
			"item": ["res://scenes/Rooms/UR_Rooms/room_ur_item.tscn"],
			"boss": ["res://scenes/Rooms/UR_Rooms/room_ur_empty.tscn"]
		},
		"ud": {
			"normal": [
				"res://scenes/Rooms/UD_Rooms/room_ud_empty.tscn",
				"res://scenes/Rooms/UD_Rooms/room_ud_1.tscn"
				],
			"start": ["res://scenes/Rooms/UD_Rooms/room_ud_start.tscn"],
			"item": ["res://scenes/Rooms/UD_Rooms/room_ud_item.tscn"],
			"boss": ["res://scenes/Rooms/UD_Rooms/room_ud_empty.tscn"]
		},
		"ul": {
			"normal": [
				"res://scenes/Rooms/UL_Rooms/room_ul_empty.tscn",
				"res://scenes/Rooms/UL_Rooms/room_ul_1.tscn"
			],
			"start": ["res://scenes/Rooms/UL_Rooms/room_ul_start.tscn"],
			"item": ["res://scenes/Rooms/UL_Rooms/room_ul_item.tscn"],
			"boss": ["res://scenes/Rooms/UL_Rooms/room_ul_empty.tscn"]
		},
		"rd": {
			"normal": [
				"res://scenes/Rooms/RD_Rooms/room_rd_empty.tscn",
				"res://scenes/Rooms/RD_Rooms/room_rd_1.tscn"
				],
			"start": ["res://scenes/Rooms/RD_Rooms/room_rd_start.tscn"],
			"item": ["res://scenes/Rooms/RD_Rooms/room_rd_item.tscn"],
			"boss": ["res://scenes/Rooms/RD_Rooms/room_rd_empty.tscn"]
		},
		"rl": {
			"normal": [
				"res://scenes/Rooms/RL_Rooms/room_rl_empty.tscn",
				"res://scenes/Rooms/RL_Rooms/room_rl_1.tscn"
				],
			"start": ["res://scenes/Rooms/RL_Rooms/room_rl_start.tscn"],
			"item": ["res://scenes/Rooms/RL_Rooms/room_rl_item.tscn"],
			"boss": ["res://scenes/Rooms/RL_Rooms/room_rl_empty.tscn"]
		},
		"dl": {
			"normal": [
				"res://scenes/Rooms/DL_Rooms/room_dl_empty.tscn",
				"res://scenes/Rooms/DL_Rooms/room_dl_1.tscn"
				],
			"start": ["res://scenes/Rooms/DL_Rooms/room_dl_start.tscn"],
			"item": ["res://scenes/Rooms/DL_Rooms/room_dl_item.tscn"],
			"boss": ["res://scenes/Rooms/DL_Rooms/room_dl_empty.tscn"]
		},
		"u": {
			"normal": [
				"res://scenes/Rooms/U_Rooms/room_u_empty.tscn",
				"res://scenes/Rooms/U_Rooms/room_u_1.tscn"
				],
			"start": ["res://scenes/Rooms/U_Rooms/room_u_start.tscn"],
			"item": ["res://scenes/Rooms/U_Rooms/room_u_item.tscn"],
			"boss": ["res://scenes/Rooms/U_Rooms/room_u_empty.tscn"]
		},
		"r": {
			"normal": [
				"res://scenes/Rooms/R_Rooms/room_r_empty.tscn",
				"res://scenes/Rooms/R_Rooms/room_r_1.tscn"
				],
			"start": ["res://scenes/Rooms/R_Rooms/room_r_start.tscn"],
			"item": ["res://scenes/Rooms/R_Rooms/room_r_item.tscn"],
			"boss": ["res://scenes/Rooms/R_Rooms/room_r_empty.tscn"]
		},
		"d": {
			"normal": [
				"res://scenes/Rooms/D_Rooms/room_d_empty.tscn",
				"res://scenes/Rooms/D_Rooms/room_d_1.tscn"
				],
			"start": ["res://scenes/Rooms/D_Rooms/room_d_start.tscn"],
			"item": ["res://scenes/Rooms/D_Rooms/room_d_item.tscn"],
			"boss": ["res://scenes/Rooms/D_Rooms/room_d_empty.tscn"]
		},
		"l": {
			"normal": [
				"res://scenes/Rooms/L_Rooms/room_l_empty.tscn",
				"res://scenes/Rooms/L_Rooms/room_l_1.tscn"
				],
			"start": ["res://scenes/Rooms/L_Rooms/room_l_start.tscn"],
			"item": ["res://scenes/Rooms/L_Rooms/room_l_item.tscn"],
			"boss": ["res://scenes/Rooms/L_Rooms/room_l_empty.tscn"]
		}
	},
	2: {
		# Add more for floor 2
	},
	# Add more floors as needed
}

# Utility function to get options for a given floor, door combo, and room type
static func get_options(cur_floor: int, door_combo: String, room_type: String = "normal") -> Array:
	if ROOM_OPTIONS.has(cur_floor) and ROOM_OPTIONS[cur_floor].has(door_combo):
		var entry = ROOM_OPTIONS[cur_floor][door_combo]
		if typeof(entry) == TYPE_DICTIONARY and entry.has(room_type):
			return entry[room_type]
		elif typeof(entry) == TYPE_ARRAY and room_type == "normal":
			return entry
	return []
