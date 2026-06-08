extends Node


static var ROOM_OPTIONS = {
	1: {
		"urdl": {
			"normal": [
				"res://scenes/Rooms/Floor1/URDL_Rooms/room_urdl_empty.tscn",
				"res://scenes/Rooms/Floor1/URDL_Rooms/room_urdl_1.tscn",
				"res://scenes/Rooms/Floor1/URDL_Rooms/room_urdl_2.tscn",
				"res://scenes/Rooms/Floor1/URDL_Rooms/room_urdl_3.tscn"
				],
			"start": ["res://scenes/Rooms/Floor1/URDL_Rooms/room_urdl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/URDL_Rooms/room_urdl_item.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor1/URDL_Rooms/room_urdl_empty.tscn",
				"res://scenes/Rooms/Floor1/URDL_Rooms/room_urdl_2.tscn"
			]
		},
		"urd": {
			"normal": [
				"res://scenes/Rooms/Floor1/URD_Rooms/room_urd_empty.tscn",
				"res://scenes/Rooms/Floor1/URD_Rooms/room_urd_1.tscn",
				],
			"start": ["res://scenes/Rooms/Floor1/URD_Rooms/room_urd_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/URD_Rooms/room_urd_item.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor1/URD_Rooms/room_urd_empty.tscn",
				"res://scenes/Rooms/Floor1/URD_Rooms/room_urd_1.tscn",
			]
		},
		"rdl": {
			"normal": [
				"res://scenes/Rooms/Floor1/RDL_Rooms/room_rdl_empty.tscn",
				"res://scenes/Rooms/Floor1/RDL_Rooms/room_rdl_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor1/RDL_Rooms/room_rdl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/RDL_Rooms/room_rdl_item.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor1/RDL_Rooms/room_rdl_empty.tscn",
				"res://scenes/Rooms/Floor1/RDL_Rooms/room_rdl_1.tscn"
			]
		},
		"udl": {
			"normal": [
				"res://scenes/Rooms/Floor1/UDL_Rooms/room_udl_empty.tscn",
				"res://scenes/Rooms/Floor1/UDL_Rooms/room_udl_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor1/UDL_Rooms/room_udl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/UDL_Rooms/room_udl_item.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor1/UDL_Rooms/room_udl_empty.tscn",
				"res://scenes/Rooms/Floor1/UDL_Rooms/room_udl_1.tscn"
				]
		},
		"url": {
			"normal": [
				"res://scenes/Rooms/Floor1/URL_Rooms/room_url_empty.tscn",
				"res://scenes/Rooms/Floor1/URL_Rooms/room_url_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor1/URL_Rooms/room_url_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/URL_Rooms/room_url_item.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor1/URL_Rooms/room_url_empty.tscn",
				"res://scenes/Rooms/Floor1/URL_Rooms/room_url_1.tscn"
				]
		},
		"ur": {
			"normal": [
				"res://scenes/Rooms/Floor1/UR_Rooms/room_ur_empty.tscn",
				"res://scenes/Rooms/Floor1/UR_Rooms/room_ur_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor1/UR_Rooms/room_ur_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/UR_Rooms/room_ur_item.tscn"],
			"boss": ["res://scenes/Rooms/Floor1/UR_Rooms/room_ur_empty.tscn"]
		},
		"ud": {
			"normal": [
				"res://scenes/Rooms/Floor1/UD_Rooms/room_ud_empty.tscn",
				"res://scenes/Rooms/Floor1/UD_Rooms/room_ud_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor1/UD_Rooms/room_ud_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/UD_Rooms/room_ud_item.tscn"],
			"boss": ["res://scenes/Rooms/Floor1/UD_Rooms/room_ud_empty.tscn"]
		},
		"ul": {
			"normal": [
				"res://scenes/Rooms/Floor1/UL_Rooms/room_ul_empty.tscn",
				"res://scenes/Rooms/Floor1/UL_Rooms/room_ul_1.tscn"
			],
			"start": ["res://scenes/Rooms/Floor1/UL_Rooms/room_ul_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/UL_Rooms/room_ul_item.tscn"],
			"boss": ["res://scenes/Rooms/Floor1/UL_Rooms/room_ul_empty.tscn"]
		},
		"rd": {
			"normal": [
				"res://scenes/Rooms/Floor1/RD_Rooms/room_rd_empty.tscn",
				"res://scenes/Rooms/Floor1/RD_Rooms/room_rd_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor1/RD_Rooms/room_rd_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/RD_Rooms/room_rd_item.tscn"],
			"boss": ["res://scenes/Rooms/Floor1/RD_Rooms/room_rd_empty.tscn"]
		},
		"rl": {
			"normal": [
				"res://scenes/Rooms/Floor1/RL_Rooms/room_rl_empty.tscn",
				"res://scenes/Rooms/Floor1/RL_Rooms/room_rl_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor1/RL_Rooms/room_rl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/RL_Rooms/room_rl_item.tscn"],
			"boss": ["res://scenes/Rooms/Floor1/RL_Rooms/room_rl_empty.tscn"]
		},
		"dl": {
			"normal": [
				"res://scenes/Rooms/Floor1/DL_Rooms/room_dl_empty.tscn",
				"res://scenes/Rooms/Floor1/DL_Rooms/room_dl_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor1/DL_Rooms/room_dl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/DL_Rooms/room_dl_item.tscn"],
			"boss": ["res://scenes/Rooms/Floor1/DL_Rooms/room_dl_empty.tscn"]
		},
		"u": {
			"normal": [
				"res://scenes/Rooms/Floor1/U_Rooms/room_u_empty.tscn",
				"res://scenes/Rooms/Floor1/U_Rooms/room_u_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor1/U_Rooms/room_u_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/U_Rooms/room_u_item.tscn"],
			"boss": ["res://scenes/Rooms/Floor1/U_Rooms/room_u_empty.tscn"]
		},
		"r": {
			"normal": [
				"res://scenes/Rooms/Floor1/R_Rooms/room_r_empty.tscn",
				"res://scenes/Rooms/Floor1/R_Rooms/room_r_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor1/R_Rooms/room_r_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/R_Rooms/room_r_item.tscn"],
			"boss": ["res://scenes/Rooms/Floor1/R_Rooms/room_r_empty.tscn"]
		},
		"d": {
			"normal": [
				"res://scenes/Rooms/Floor1/D_Rooms/room_d_empty.tscn",
				"res://scenes/Rooms/Floor1/D_Rooms/room_d_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor1/D_Rooms/room_d_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/D_Rooms/room_d_item.tscn"],
			"boss": ["res://scenes/Rooms/Floor1/D_Rooms/room_d_empty.tscn"]
		},
		"l": {
			"normal": [
				"res://scenes/Rooms/Floor1/L_Rooms/room_l_empty.tscn",
				"res://scenes/Rooms/Floor1/L_Rooms/room_l_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor1/L_Rooms/room_l_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/L_Rooms/room_l_item.tscn"],
			"boss": ["res://scenes/Rooms/Floor1/L_Rooms/room_l_empty.tscn"]
		}
	},
	2: {
		"urdl": {
			"normal": [
				"res://scenes/Rooms/Floor1/URDL_Rooms/room_urdl_empty.tscn",
				"res://scenes/Rooms/Floor1/URDL_Rooms/room_urdl_1.tscn",
				"res://scenes/Rooms/Floor1/URDL_Rooms/room_urdl_2.tscn",
				"res://scenes/Rooms/Floor1/URDL_Rooms/room_urdl_3.tscn"
				],
			"start": ["res://scenes/Rooms/Floor2/URDL_Rooms/room_urdl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/URDL_Rooms/room_urdl_item.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor2/URDL_Rooms/room_urdl_boss.tscn"
			]
		},
		"urd": {
			"normal": [
				"res://scenes/Rooms/Floor1/URD_Rooms/room_urd_empty.tscn",
				"res://scenes/Rooms/Floor1/URD_Rooms/room_urd_1.tscn",
				],
			"start": ["res://scenes/Rooms/Floor2/URD_Rooms/room_urd_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/URD_Rooms/room_urd_item.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor2/URD_Rooms/room_urd_boss.tscn"
			]
		},
		"rdl": {
			"normal": [
				"res://scenes/Rooms/Floor1/RDL_Rooms/room_rdl_empty.tscn",
				"res://scenes/Rooms/Floor1/RDL_Rooms/room_rdl_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor2/RDL_Rooms/room_rdl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/RDL_Rooms/room_rdl_item.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor2/RDL_Rooms/room_rdl_boss.tscn"
			]
		},
		"udl": {
			"normal": [
				"res://scenes/Rooms/Floor1/UDL_Rooms/room_udl_empty.tscn",
				"res://scenes/Rooms/Floor1/UDL_Rooms/room_udl_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor2/UDL_Rooms/room_udl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/UDL_Rooms/room_udl_item.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor2/UDL_Rooms/room_udl_boss.tscn"
				]
		},
		"url": {
			"normal": [
				"res://scenes/Rooms/Floor1/URL_Rooms/room_url_empty.tscn",
				"res://scenes/Rooms/Floor1/URL_Rooms/room_url_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor2/URL_Rooms/room_url_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/URL_Rooms/room_url_item.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor2/URL_Rooms/room_url_boss.tscn"
				]
		},
		"ur": {
			"normal": [
				"res://scenes/Rooms/Floor1/UR_Rooms/room_ur_empty.tscn",
				"res://scenes/Rooms/Floor1/UR_Rooms/room_ur_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor2/UR_Rooms/room_ur_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/UR_Rooms/room_ur_item.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/UR_Rooms/room_ur_boss.tscn"]
		},
		"ud": {
			"normal": [
				"res://scenes/Rooms/Floor1/UD_Rooms/room_ud_empty.tscn",
				"res://scenes/Rooms/Floor1/UD_Rooms/room_ud_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor2/UD_Rooms/room_ud_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/UD_Rooms/room_ud_item.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/UD_Rooms/room_ud_boss.tscn"]
		},
		"ul": {
			"normal": [
				"res://scenes/Rooms/Floor1/UL_Rooms/room_ul_empty.tscn",
				"res://scenes/Rooms/Floor1/UL_Rooms/room_ul_1.tscn"
			],
			"start": ["res://scenes/Rooms/Floor2/UL_Rooms/room_ul_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/UL_Rooms/room_ul_item.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/UL_Rooms/room_ul_boss.tscn"]
		},
		"rd": {
			"normal": [
				"res://scenes/Rooms/Floor1/RD_Rooms/room_rd_empty.tscn",
				"res://scenes/Rooms/Floor1/RD_Rooms/room_rd_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor2/RD_Rooms/room_rd_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/RD_Rooms/room_rd_item.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/RD_Rooms/room_rd_boss.tscn"]
		},
		"rl": {
			"normal": [
				"res://scenes/Rooms/Floor1/RL_Rooms/room_rl_empty.tscn",
				"res://scenes/Rooms/Floor1/RL_Rooms/room_rl_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor2/RL_Rooms/room_rl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/RL_Rooms/room_rl_item.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/RL_Rooms/room_rl_boss.tscn"]
		},
		"dl": {
			"normal": [
				"res://scenes/Rooms/Floor1/DL_Rooms/room_dl_empty.tscn",
				"res://scenes/Rooms/Floor1/DL_Rooms/room_dl_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor2/DL_Rooms/room_dl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/DL_Rooms/room_dl_item.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/DL_Rooms/room_dl_boss.tscn"]
		},
		"u": {
			"normal": [
				"res://scenes/Rooms/Floor1/U_Rooms/room_u_empty.tscn",
				"res://scenes/Rooms/Floor1/U_Rooms/room_u_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor2/U_Rooms/room_u_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/U_Rooms/room_u_item.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/U_Rooms/room_u_boss.tscn"]
		},
		"r": {
			"normal": [
				"res://scenes/Rooms/Floor1/R_Rooms/room_r_empty.tscn",
				"res://scenes/Rooms/Floor1/R_Rooms/room_r_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor2/R_Rooms/room_r_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/R_Rooms/room_r_item.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/R_Rooms/room_r_boss.tscn"]
		},
		"d": {
			"normal": [
				"res://scenes/Rooms/Floor1/D_Rooms/room_d_empty.tscn",
				"res://scenes/Rooms/Floor1/D_Rooms/room_d_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor2/D_Rooms/room_d_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/D_Rooms/room_d_item.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/D_Rooms/room_d_boss.tscn"]
		},
		"l": {
			"normal": [
				"res://scenes/Rooms/Floor1/L_Rooms/room_l_empty.tscn",
				"res://scenes/Rooms/Floor1/L_Rooms/room_l_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor2/L_Rooms/room_l_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/L_Rooms/room_l_item.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/L_Rooms/room_l_boss.tscn"]
		}
	},
	3: {
		"urdl": {
			"normal": [
				"res://scenes/Rooms/Floor1/URDL_Rooms/room_urdl_empty.tscn",
				"res://scenes/Rooms/Floor1/URDL_Rooms/room_urdl_1.tscn",
				"res://scenes/Rooms/Floor1/URDL_Rooms/room_urdl_2.tscn",
				"res://scenes/Rooms/Floor1/URDL_Rooms/room_urdl_3.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/URDL_Rooms/room_urdl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/URDL_Rooms/room_urdl_item.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor2/URDL_Rooms/room_urdl_boss.tscn"
			]
		},
		"urd": {
			"normal": [
				"res://scenes/Rooms/Floor1/URD_Rooms/room_urd_empty.tscn",
				"res://scenes/Rooms/Floor1/URD_Rooms/room_urd_1.tscn",
				],
			"start": ["res://scenes/Rooms/Floor3/URD_Rooms/room_urd_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/URD_Rooms/room_urd_item.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor2/URD_Rooms/room_urd_boss.tscn"
			]
		},
		"rdl": {
			"normal": [
				"res://scenes/Rooms/Floor1/RDL_Rooms/room_rdl_empty.tscn",
				"res://scenes/Rooms/Floor1/RDL_Rooms/room_rdl_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/RDL_Rooms/room_rdl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/RDL_Rooms/room_rdl_item.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor2/RDL_Rooms/room_rdl_boss.tscn"
			]
		},
		"udl": {
			"normal": [
				"res://scenes/Rooms/Floor1/UDL_Rooms/room_udl_empty.tscn",
				"res://scenes/Rooms/Floor1/UDL_Rooms/room_udl_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/UDL_Rooms/room_udl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/UDL_Rooms/room_udl_item.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor2/UDL_Rooms/room_udl_boss.tscn"
				]
		},
		"url": {
			"normal": [
				"res://scenes/Rooms/Floor1/URL_Rooms/room_url_empty.tscn",
				"res://scenes/Rooms/Floor1/URL_Rooms/room_url_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/URL_Rooms/room_url_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/URL_Rooms/room_url_item.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor2/URL_Rooms/room_url_boss.tscn"
				]
		},
		"ur": {
			"normal": [
				"res://scenes/Rooms/Floor1/UR_Rooms/room_ur_empty.tscn",
				"res://scenes/Rooms/Floor1/UR_Rooms/room_ur_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/UR_Rooms/room_ur_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/UR_Rooms/room_ur_item.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/UR_Rooms/room_ur_boss.tscn"]
		},
		"ud": {
			"normal": [
				"res://scenes/Rooms/Floor1/UD_Rooms/room_ud_empty.tscn",
				"res://scenes/Rooms/Floor3/UD_Rooms/room_ud_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/UD_Rooms/room_ud_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/UD_Rooms/room_ud_item.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/UD_Rooms/room_ud_boss.tscn"]
		},
		"ul": {
			"normal": [
				"res://scenes/Rooms/Floor1/UL_Rooms/room_ul_empty.tscn",
				"res://scenes/Rooms/Floor1/UL_Rooms/room_ul_1.tscn"
			],
			"start": ["res://scenes/Rooms/Floor3/UL_Rooms/room_ul_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/UL_Rooms/room_ul_item.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/UL_Rooms/room_ul_boss.tscn"]
		},
		"rd": {
			"normal": [
				"res://scenes/Rooms/Floor1/RD_Rooms/room_rd_empty.tscn",
				"res://scenes/Rooms/Floor1/RD_Rooms/room_rd_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/RD_Rooms/room_rd_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/RD_Rooms/room_rd_item.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/RD_Rooms/room_rd_boss.tscn"]
		},
		"rl": {
			"normal": [
				"res://scenes/Rooms/Floor1/RL_Rooms/room_rl_empty.tscn",
				"res://scenes/Rooms/Floor1/RL_Rooms/room_rl_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/RL_Rooms/room_rl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/RL_Rooms/room_rl_item.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/RL_Rooms/room_rl_boss.tscn"]
		},
		"dl": {
			"normal": [
				"res://scenes/Rooms/Floor1/DL_Rooms/room_dl_empty.tscn",
				"res://scenes/Rooms/Floor3/DL_Rooms/room_dl_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/DL_Rooms/room_dl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/DL_Rooms/room_dl_item.tscn"],
			"boss": ["res://scenes/Rooms/Floor3/DL_Rooms/room_dl_boss.tscn"]
		},
		"u": {
			"normal": [
				"res://scenes/Rooms/Floor1/U_Rooms/room_u_empty.tscn",
				"res://scenes/Rooms/Floor1/U_Rooms/room_u_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/U_Rooms/room_u_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/U_Rooms/room_u_item.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/U_Rooms/room_u_boss.tscn"]
		},
		"r": {
			"normal": [
				"res://scenes/Rooms/Floor1/R_Rooms/room_r_empty.tscn",
				"res://scenes/Rooms/Floor1/R_Rooms/room_r_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/R_Rooms/room_r_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/R_Rooms/room_r_item.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/R_Rooms/room_r_boss.tscn"]
		},
		"d": {
			"normal": [
				"res://scenes/Rooms/Floor1/D_Rooms/room_d_empty.tscn",
				"res://scenes/Rooms/Floor1/D_Rooms/room_d_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/D_Rooms/room_d_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/D_Rooms/room_d_item.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/D_Rooms/room_d_boss.tscn"]
		},
		"l": {
			"normal": [
				"res://scenes/Rooms/Floor1/L_Rooms/room_l_empty.tscn",
				"res://scenes/Rooms/Floor1/L_Rooms/room_l_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/L_Rooms/room_l_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/L_Rooms/room_l_item.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/L_Rooms/room_l_boss.tscn"]
		}
	},
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
