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
			"miniboss": ["res://scenes/Rooms/Floor1/URDL_Rooms/room_urdl_miniboss.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor2/URDL_Rooms/room_urdl_boss.tscn"
			]
		},
		"urd": {
			"normal": [
				"res://scenes/Rooms/Floor1/URD_Rooms/room_urd_empty.tscn",
				"res://scenes/Rooms/Floor1/URD_Rooms/room_urd_1.tscn",
				],
			"start": ["res://scenes/Rooms/Floor1/URD_Rooms/room_urd_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/URD_Rooms/room_urd_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor1/URD_Rooms/room_urd_miniboss.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor2/URD_Rooms/room_urd_boss.tscn"
			]
		},
		"rdl": {
			"normal": [
				"res://scenes/Rooms/Floor1/RDL_Rooms/room_rdl_empty.tscn",
				"res://scenes/Rooms/Floor1/RDL_Rooms/room_rdl_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor1/RDL_Rooms/room_rdl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/RDL_Rooms/room_rdl_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor1/RDL_Rooms/room_rdl_miniboss.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor2/RDL_Rooms/room_rdl_boss.tscn"
			]
		},
		"udl": {
			"normal": [
				"res://scenes/Rooms/Floor1/UDL_Rooms/room_udl_empty.tscn",
				"res://scenes/Rooms/Floor1/UDL_Rooms/room_udl_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor1/UDL_Rooms/room_udl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/UDL_Rooms/room_udl_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor1/UDL_Rooms/room_udl_miniboss.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor2/UDL_Rooms/room_udl_boss.tscn"
				]
		},
		"url": {
			"normal": [
				"res://scenes/Rooms/Floor1/URL_Rooms/room_url_empty.tscn",
				"res://scenes/Rooms/Floor1/URL_Rooms/room_url_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor1/URL_Rooms/room_url_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/URL_Rooms/room_url_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor1/URL_Rooms/room_url_miniboss.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor2/URL_Rooms/room_url_boss.tscn"
				]
		},
		"ur": {
			"normal": [
				"res://scenes/Rooms/Floor1/UR_Rooms/room_ur_empty.tscn",
				"res://scenes/Rooms/Floor1/UR_Rooms/room_ur_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor1/UR_Rooms/room_ur_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/UR_Rooms/room_ur_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor1/UR_Rooms/room_ur_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/UR_Rooms/room_ur_boss.tscn"]
		},
		"ud": {
			"normal": [
				"res://scenes/Rooms/Floor1/UD_Rooms/room_ud_empty.tscn",
				"res://scenes/Rooms/Floor1/UD_Rooms/room_ud_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor1/UD_Rooms/room_ud_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/UD_Rooms/room_ud_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor1/UD_Rooms/room_ud_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/UD_Rooms/room_ud_boss.tscn"]
		},
		"ul": {
			"normal": [
				"res://scenes/Rooms/Floor1/UL_Rooms/room_ul_empty.tscn",
				"res://scenes/Rooms/Floor1/UL_Rooms/room_ul_1.tscn"
			],
			"start": ["res://scenes/Rooms/Floor1/UL_Rooms/room_ul_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/UL_Rooms/room_ul_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor1/UL_Rooms/room_ul_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/UL_Rooms/room_ul_boss.tscn"]
		},
		"rd": {
			"normal": [
				"res://scenes/Rooms/Floor1/RD_Rooms/room_rd_empty.tscn",
				"res://scenes/Rooms/Floor1/RD_Rooms/room_rd_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor1/RD_Rooms/room_rd_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/RD_Rooms/room_rd_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor1/RD_Rooms/room_rd_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/RD_Rooms/room_rd_boss.tscn"]
		},
		"rl": {
			"normal": [
				"res://scenes/Rooms/Floor1/RL_Rooms/room_rl_empty.tscn",
				"res://scenes/Rooms/Floor1/RL_Rooms/room_rl_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor1/RL_Rooms/room_rl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/RL_Rooms/room_rl_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor1/RL_Rooms/room_rl_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/RL_Rooms/room_rl_boss.tscn"]
		},
		"dl": {
			"normal": [
				"res://scenes/Rooms/Floor1/DL_Rooms/room_dl_empty.tscn",
				"res://scenes/Rooms/Floor1/DL_Rooms/room_dl_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor1/DL_Rooms/room_dl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/DL_Rooms/room_dl_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor1/DL_Rooms/room_dl_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/DL_Rooms/room_dl_boss.tscn"]
		},
		"u": {
			"normal": [
				"res://scenes/Rooms/Floor1/U_Rooms/room_u_empty.tscn",
				"res://scenes/Rooms/Floor1/U_Rooms/room_u_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor1/U_Rooms/room_u_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/U_Rooms/room_u_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor1/U_Rooms/room_u_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/U_Rooms/room_u_boss.tscn"]
		},
		"r": {
			"normal": [
				"res://scenes/Rooms/Floor1/R_Rooms/room_r_empty.tscn",
				"res://scenes/Rooms/Floor1/R_Rooms/room_r_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor1/R_Rooms/room_r_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/R_Rooms/room_r_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor1/R_Rooms/room_r_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/R_Rooms/room_r_boss.tscn"]
		},
		"d": {
			"normal": [
				"res://scenes/Rooms/Floor1/D_Rooms/room_d_empty.tscn",
				"res://scenes/Rooms/Floor1/D_Rooms/room_d_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor1/D_Rooms/room_d_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/D_Rooms/room_d_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor1/D_Rooms/room_d_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/D_Rooms/room_d_boss.tscn"]
		},
		"l": {
			"normal": [
				"res://scenes/Rooms/Floor1/L_Rooms/room_l_empty.tscn",
				"res://scenes/Rooms/Floor1/L_Rooms/room_l_1.tscn"
				],
			"start": ["res://scenes/Rooms/Floor1/L_Rooms/room_l_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/L_Rooms/room_l_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor1/L_Rooms/room_l_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/L_Rooms/room_l_boss.tscn"]
		}
	},
	2: {
		"urdl": {
			"normal": [
				"res://scenes/Rooms/Floor1/URDL_Rooms/room_urdl_empty.tscn",
				"res://scenes/Rooms/Floor1/URDL_Rooms/room_urdl_1.tscn",
				"res://scenes/Rooms/Floor1/URDL_Rooms/room_urdl_2.tscn",
				"res://scenes/Rooms/Floor1/URDL_Rooms/room_urdl_3.tscn",
				"res://scenes/Rooms/Floor2/URDL_Rooms/room_urdl_spikes.tscn"
			],
			"start": ["res://scenes/Rooms/Floor2/URDL_Rooms/room_urdl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/URDL_Rooms/room_urdl_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor1/URDL_Rooms/room_urdl_miniboss.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor2/URDL_Rooms/room_urdl_boss.tscn"
			]
		},
		"urd": {
			"normal": [
				"res://scenes/Rooms/Floor1/URD_Rooms/room_urd_empty.tscn",
				"res://scenes/Rooms/Floor1/URD_Rooms/room_urd_1.tscn",
				"res://scenes/Rooms/Floor2/URD_Rooms/room_urd_spikes.tscn"
			],
			"start": ["res://scenes/Rooms/Floor2/URD_Rooms/room_urd_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/URD_Rooms/room_urd_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor1/URD_Rooms/room_urd_miniboss.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor2/URD_Rooms/room_urd_boss.tscn"
			]
		},
		"rdl": {
			"normal": [
				"res://scenes/Rooms/Floor1/RDL_Rooms/room_rdl_empty.tscn",
				"res://scenes/Rooms/Floor1/RDL_Rooms/room_rdl_1.tscn",
				"res://scenes/Rooms/Floor2/RDL_Rooms/room_rdl_spikes.tscn"
			],
			"start": ["res://scenes/Rooms/Floor2/RDL_Rooms/room_rdl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/RDL_Rooms/room_rdl_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor1/RDL_Rooms/room_rdl_miniboss.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor2/RDL_Rooms/room_rdl_boss.tscn"
			]
		},
		"udl": {
			"normal": [
				"res://scenes/Rooms/Floor1/UDL_Rooms/room_udl_empty.tscn",
				"res://scenes/Rooms/Floor1/UDL_Rooms/room_udl_1.tscn",
				"res://scenes/Rooms/Floor2/UDL_Rooms/room_udl_spikes.tscn"
			],
			"start": ["res://scenes/Rooms/Floor2/UDL_Rooms/room_udl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/UDL_Rooms/room_udl_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor1/UDL_Rooms/room_udl_miniboss.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor2/UDL_Rooms/room_udl_boss.tscn"
				]
		},
		"url": {
			"normal": [
				"res://scenes/Rooms/Floor1/URL_Rooms/room_url_empty.tscn",
				"res://scenes/Rooms/Floor1/URL_Rooms/room_url_1.tscn",
				"res://scenes/Rooms/Floor2/URL_Rooms/room_url_spikes.tscn"
			],
			"start": ["res://scenes/Rooms/Floor2/URL_Rooms/room_url_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/URL_Rooms/room_url_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor1/URL_Rooms/room_url_miniboss.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor2/URL_Rooms/room_url_boss.tscn"
				]
		},
		"ur": {
			"normal": [
				"res://scenes/Rooms/Floor1/UR_Rooms/room_ur_empty.tscn",
				"res://scenes/Rooms/Floor1/UR_Rooms/room_ur_1.tscn",
				"res://scenes/Rooms/Floor2/UR_Rooms/room_ur_spikes.tscn"
			],
			"start": ["res://scenes/Rooms/Floor2/UR_Rooms/room_ur_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/UR_Rooms/room_ur_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor1/UR_Rooms/room_ur_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/UR_Rooms/room_ur_boss.tscn"]
		},
		"ud": {
			"normal": [
				"res://scenes/Rooms/Floor1/UD_Rooms/room_ud_empty.tscn",
				"res://scenes/Rooms/Floor1/UD_Rooms/room_ud_1.tscn",
				"res://scenes/Rooms/Floor2/UD_Rooms/room_ud_spikes.tscn"
			],
			"start": ["res://scenes/Rooms/Floor2/UD_Rooms/room_ud_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/UD_Rooms/room_ud_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor1/UD_Rooms/room_ud_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/UD_Rooms/room_ud_boss.tscn"]
		},
		"ul": {
			"normal": [
				"res://scenes/Rooms/Floor1/UL_Rooms/room_ul_empty.tscn",
				"res://scenes/Rooms/Floor1/UL_Rooms/room_ul_1.tscn",
				"res://scenes/Rooms/Floor2/UL_Rooms/room_ul_spikes.tscn"
			],
			"start": ["res://scenes/Rooms/Floor2/UL_Rooms/room_ul_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/UL_Rooms/room_ul_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor1/UL_Rooms/room_ul_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/UL_Rooms/room_ul_boss.tscn"]
		},
		"rd": {
			"normal": [
				"res://scenes/Rooms/Floor1/RD_Rooms/room_rd_empty.tscn",
				"res://scenes/Rooms/Floor1/RD_Rooms/room_rd_1.tscn",
				"res://scenes/Rooms/Floor2/RD_Rooms/room_rd_spikes.tscn"
			],
			"start": ["res://scenes/Rooms/Floor2/RD_Rooms/room_rd_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/RD_Rooms/room_rd_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor1/RD_Rooms/room_rd_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/RD_Rooms/room_rd_boss.tscn"]
		},
		"rl": {
			"normal": [
				"res://scenes/Rooms/Floor1/RL_Rooms/room_rl_empty.tscn",
				"res://scenes/Rooms/Floor1/RL_Rooms/room_rl_1.tscn",
				"res://scenes/Rooms/Floor2/RL_Rooms/room_rl_spikes.tscn"
			],
			"start": ["res://scenes/Rooms/Floor2/RL_Rooms/room_rl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/RL_Rooms/room_rl_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor1/RL_Rooms/room_rl_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/RL_Rooms/room_rl_boss.tscn"]
		},
		"dl": {
			"normal": [
				"res://scenes/Rooms/Floor1/DL_Rooms/room_dl_empty.tscn",
				"res://scenes/Rooms/Floor1/DL_Rooms/room_dl_1.tscn",
				"res://scenes/Rooms/Floor2/DL_Rooms/room_dl_spikes.tscn"
			],
			"start": ["res://scenes/Rooms/Floor2/DL_Rooms/room_dl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/DL_Rooms/room_dl_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor1/DL_Rooms/room_dl_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/DL_Rooms/room_dl_boss.tscn"]
		},
		"u": {
			"normal": [
				"res://scenes/Rooms/Floor1/U_Rooms/room_u_empty.tscn",
				"res://scenes/Rooms/Floor1/U_Rooms/room_u_1.tscn",
				"res://scenes/Rooms/Floor2/U_Rooms/room_u_spikes.tscn"
			],
			"start": ["res://scenes/Rooms/Floor2/U_Rooms/room_u_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/U_Rooms/room_u_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor1/U_Rooms/room_u_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/U_Rooms/room_u_boss.tscn"]
		},
		"r": {
			"normal": [
				"res://scenes/Rooms/Floor1/R_Rooms/room_r_empty.tscn",
				"res://scenes/Rooms/Floor1/R_Rooms/room_r_1.tscn",
				"res://scenes/Rooms/Floor2/R_Rooms/room_r_spikes.tscn"
			],
			"start": ["res://scenes/Rooms/Floor2/R_Rooms/room_r_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/R_Rooms/room_r_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor1/R_Rooms/room_r_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/R_Rooms/room_r_boss.tscn"]
		},
		"d": {
			"normal": [
				"res://scenes/Rooms/Floor1/D_Rooms/room_d_empty.tscn",
				"res://scenes/Rooms/Floor1/D_Rooms/room_d_1.tscn",
				"res://scenes/Rooms/Floor2/D_Rooms/room_d_spikes.tscn"
			],
			"start": ["res://scenes/Rooms/Floor2/D_Rooms/room_d_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/D_Rooms/room_d_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor1/D_Rooms/room_d_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/D_Rooms/room_d_boss.tscn"]
		},
		"l": {
			"normal": [
				"res://scenes/Rooms/Floor1/L_Rooms/room_l_empty.tscn",
				"res://scenes/Rooms/Floor1/L_Rooms/room_l_1.tscn",
				"res://scenes/Rooms/Floor2/L_Rooms/room_l_spikes.tscn"
			],
			"start": ["res://scenes/Rooms/Floor2/L_Rooms/room_l_start.tscn"],
			"item": ["res://scenes/Rooms/Floor1/L_Rooms/room_l_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor1/L_Rooms/room_l_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor2/L_Rooms/room_l_boss.tscn"]
		}
	},
	3: {
		"urdl": {
			"normal": [
				"res://scenes/Rooms/Floor3/URDL_Rooms/room_urdl.tscn",
				"res://scenes/Rooms/Floor3/URDL_Rooms/room_urdl_2.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/URDL_Rooms/room_urdl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/URDL_Rooms/room_urdl_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor3/URDL_Rooms/room_urdl_miniboss.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor3/URDL_Rooms/room_urdl_boss.tscn"
			]
		},
		"urd": {
			"normal": [
				"res://scenes/Rooms/Floor3/URD_Rooms/room_urd.tscn",
				"res://scenes/Rooms/Floor3/URD_Rooms/room_urd_2.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/URD_Rooms/room_urd_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/URD_Rooms/room_urd_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor3/URD_Rooms/room_urd_miniboss.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor3/URD_Rooms/room_urd_boss.tscn"
			]
		},
		"rdl": {
			"normal": [
				"res://scenes/Rooms/Floor3/RDL_Rooms/room_rdl.tscn",
				"res://scenes/Rooms/Floor3/RDL_Rooms/room_rdl_2.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/RDL_Rooms/room_rdl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/RDL_Rooms/room_rdl_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor3/RDL_Rooms/room_rdl_miniboss.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor3/RDL_Rooms/room_rdl_boss.tscn"
			]
		},
		"udl": {
			"normal": [
				"res://scenes/Rooms/Floor3/UDL_Rooms/room_udl.tscn",
				"res://scenes/Rooms/Floor3/UDL_Rooms/room_udl_2.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/UDL_Rooms/room_udl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/UDL_Rooms/room_udl_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor3/UDL_Rooms/room_udl_miniboss.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor3/UDL_Rooms/room_udl_boss.tscn"
				]
		},
		"url": {
			"normal": [
				"res://scenes/Rooms/Floor3/URL_Rooms/room_url.tscn",
				"res://scenes/Rooms/Floor3/URL_Rooms/room_url_2.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/URL_Rooms/room_url_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/URL_Rooms/room_url_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor3/URL_Rooms/room_url_miniboss.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor3/URL_Rooms/room_url_boss.tscn"
				]
		},
		"ur": {
			"normal": [
				"res://scenes/Rooms/Floor3/UR_Rooms/room_ur.tscn",
				"res://scenes/Rooms/Floor3/UR_Rooms/room_ur_2.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/UR_Rooms/room_ur_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/UR_Rooms/room_ur_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor3/UR_Rooms/room_ur_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor3/UR_Rooms/room_ur_boss.tscn"]
		},
		"ud": {
			"normal": [
				"res://scenes/Rooms/Floor3/UD_Rooms/room_ud.tscn",
				"res://scenes/Rooms/Floor3/UD_Rooms/room_ud_1.tscn",
				"res://scenes/Rooms/Floor3/UD_Rooms/room_ud_2.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/UD_Rooms/room_ud_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/UD_Rooms/room_ud_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor3/UD_Rooms/room_ud_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor3/UD_Rooms/room_ud_boss.tscn"]
		},
		"ul": {
			"normal": [
				"res://scenes/Rooms/Floor3/UL_Rooms/room_ul.tscn",
				"res://scenes/Rooms/Floor3/UL_Rooms/room_ul_2.tscn"
			],
			"start": ["res://scenes/Rooms/Floor3/UL_Rooms/room_ul_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/UL_Rooms/room_ul_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor3/UL_Rooms/room_ul_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor3/UL_Rooms/room_ul_boss.tscn"]
		},
		"rd": {
			"normal": [
				"res://scenes/Rooms/Floor3/RD_Rooms/room_rd_1.tscn",
				"res://scenes/Rooms/Floor3/RD_Rooms/room_rd.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/RD_Rooms/room_rd_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/RD_Rooms/room_rd_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor3/RD_Rooms/room_rd_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor3/RD_Rooms/room_rd_boss.tscn"]
		},
		"rl": {
			"normal": [
				"res://scenes/Rooms/Floor3/RL_Rooms/room_rl_1.tscn",
				"res://scenes/Rooms/Floor3/RL_Rooms/room_rl.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/RL_Rooms/room_rl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/RL_Rooms/room_rl_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor3/RL_Rooms/room_rl_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor3/RL_Rooms/room_rl_boss.tscn"]
		},
		"dl": {
			"normal": [
				"res://scenes/Rooms/Floor3/DL_Rooms/room_dl.tscn",
				"res://scenes/Rooms/Floor3/DL_Rooms/room_dl_1.tscn",
				"res://scenes/Rooms/Floor3/DL_Rooms/room_dl_2.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/DL_Rooms/room_dl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/DL_Rooms/room_dl_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor3/DL_Rooms/room_dl_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor3/DL_Rooms/room_dl_boss.tscn"]
		},
		"u": {
			"normal": [
				"res://scenes/Rooms/Floor3/U_Rooms/room_u.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/U_Rooms/room_u_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/U_Rooms/room_u_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor3/U_Rooms/room_u_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor3/U_Rooms/room_u_boss.tscn"]
		},
		"r": {
			"normal": [
				"res://scenes/Rooms/Floor3/R_Rooms/room_r.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/R_Rooms/room_r_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/R_Rooms/room_r_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor3/R_Rooms/room_r_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor3/R_Rooms/room_r_boss.tscn"]
		},
		"d": {
			"normal": [
				"res://scenes/Rooms/Floor3/D_Rooms/room_d.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/D_Rooms/room_d_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/D_Rooms/room_d_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor3/D_Rooms/room_d_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor3/D_Rooms/room_d_boss.tscn"]
		},
		"l": {
			"normal": [
				"res://scenes/Rooms/Floor3/L_Rooms/room_l.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/L_Rooms/room_l_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/L_Rooms/room_l_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor3/L_Rooms/room_l_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor3/L_Rooms/room_l_boss.tscn"]
		}
	},
	4: {
		"urdl": {
			"normal": [
				"res://scenes/Rooms/Floor3/URDL_Rooms/room_urdl.tscn",
				"res://scenes/Rooms/Floor3/URDL_Rooms/room_urdl_2.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/URDL_Rooms/room_urdl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/URDL_Rooms/room_urdl_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor3/URDL_Rooms/room_urdl_miniboss.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor3/URDL_Rooms/room_urdl_boss.tscn"
			]
		},
		"urd": {
			"normal": [
				"res://scenes/Rooms/Floor3/URD_Rooms/room_urd.tscn",
				"res://scenes/Rooms/Floor3/URD_Rooms/room_urd_2.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/URD_Rooms/room_urd_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/URD_Rooms/room_urd_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor3/URD_Rooms/room_urd_miniboss.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor3/URD_Rooms/room_urd_boss.tscn"
			]
		},
		"rdl": {
			"normal": [
				"res://scenes/Rooms/Floor3/RDL_Rooms/room_rdl.tscn",
				"res://scenes/Rooms/Floor3/RDL_Rooms/room_rdl_2.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/RDL_Rooms/room_rdl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/RDL_Rooms/room_rdl_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor3/RDL_Rooms/room_rdl_miniboss.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor3/RDL_Rooms/room_rdl_boss.tscn"
			]
		},
		"udl": {
			"normal": [
				"res://scenes/Rooms/Floor3/UDL_Rooms/room_udl.tscn",
				"res://scenes/Rooms/Floor3/UDL_Rooms/room_udl_2.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/UDL_Rooms/room_udl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/UDL_Rooms/room_udl_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor3/UDL_Rooms/room_udl_miniboss.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor3/UDL_Rooms/room_udl_boss.tscn"
				]
		},
		"url": {
			"normal": [
				"res://scenes/Rooms/Floor3/URL_Rooms/room_url.tscn",
				"res://scenes/Rooms/Floor3/URL_Rooms/room_url_2.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/URL_Rooms/room_url_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/URL_Rooms/room_url_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor3/URL_Rooms/room_url_miniboss.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor3/URL_Rooms/room_url_boss.tscn"
				]
		},
		"ur": {
			"normal": [
				"res://scenes/Rooms/Floor3/UR_Rooms/room_ur.tscn",
				"res://scenes/Rooms/Floor3/UR_Rooms/room_ur_2.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/UR_Rooms/room_ur_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/UR_Rooms/room_ur_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor3/UR_Rooms/room_ur_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor3/UR_Rooms/room_ur_boss.tscn"]
		},
		"ud": {
			"normal": [
				"res://scenes/Rooms/Floor3/UD_Rooms/room_ud.tscn",
				"res://scenes/Rooms/Floor3/UD_Rooms/room_ud_1.tscn",
				"res://scenes/Rooms/Floor3/UD_Rooms/room_ud_2.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/UD_Rooms/room_ud_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/UD_Rooms/room_ud_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor3/UD_Rooms/room_ud_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor3/UD_Rooms/room_ud_boss.tscn"]
		},
		"ul": {
			"normal": [
				"res://scenes/Rooms/Floor3/UL_Rooms/room_ul.tscn",
				"res://scenes/Rooms/Floor3/UL_Rooms/room_ul_2.tscn"
			],
			"start": ["res://scenes/Rooms/Floor3/UL_Rooms/room_ul_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/UL_Rooms/room_ul_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor3/UL_Rooms/room_ul_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor3/UL_Rooms/room_ul_boss.tscn"]
		},
		"rd": {
			"normal": [
				"res://scenes/Rooms/Floor3/RD_Rooms/room_rd_1.tscn",
				"res://scenes/Rooms/Floor3/RD_Rooms/room_rd.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/RD_Rooms/room_rd_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/RD_Rooms/room_rd_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor3/RD_Rooms/room_rd_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor3/RD_Rooms/room_rd_boss.tscn"]
		},
		"rl": {
			"normal": [
				"res://scenes/Rooms/Floor3/RL_Rooms/room_rl_1.tscn",
				"res://scenes/Rooms/Floor3/RL_Rooms/room_rl.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/RL_Rooms/room_rl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/RL_Rooms/room_rl_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor3/RL_Rooms/room_rl_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor3/RL_Rooms/room_rl_boss.tscn"]
		},
		"dl": {
			"normal": [
				"res://scenes/Rooms/Floor3/DL_Rooms/room_dl.tscn",
				"res://scenes/Rooms/Floor3/DL_Rooms/room_dl_1.tscn",
				"res://scenes/Rooms/Floor3/DL_Rooms/room_dl_2.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/DL_Rooms/room_dl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/DL_Rooms/room_dl_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor3/DL_Rooms/room_dl_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor3/DL_Rooms/room_dl_boss.tscn"]
		},
		"u": {
			"normal": [
				"res://scenes/Rooms/Floor3/U_Rooms/room_u.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/U_Rooms/room_u_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/U_Rooms/room_u_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor3/U_Rooms/room_u_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor3/U_Rooms/room_u_boss.tscn"]
		},
		"r": {
			"normal": [
				"res://scenes/Rooms/Floor3/R_Rooms/room_r.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/R_Rooms/room_r_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/R_Rooms/room_r_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor3/R_Rooms/room_r_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor3/R_Rooms/room_r_boss.tscn"]
		},
		"d": {
			"normal": [
				"res://scenes/Rooms/Floor3/D_Rooms/room_d.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/D_Rooms/room_d_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/D_Rooms/room_d_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor3/D_Rooms/room_d_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor3/D_Rooms/room_d_boss.tscn"]
		},
		"l": {
			"normal": [
				"res://scenes/Rooms/Floor3/L_Rooms/room_l.tscn"
				],
			"start": ["res://scenes/Rooms/Floor3/L_Rooms/room_l_start.tscn"],
			"item": ["res://scenes/Rooms/Floor3/L_Rooms/room_l_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor3/L_Rooms/room_l_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor3/L_Rooms/room_l_boss.tscn"]
		}
	},
	5: {
		"urdl": {
			"normal": [
				"res://scenes/Rooms/Floor5/URDL_Rooms/room_urdl.tscn",
				"res://scenes/Rooms/Floor5/URDL_Rooms/room_urdl_2.tscn"
				],
			"start": ["res://scenes/Rooms/Floor5/URDL_Rooms/room_urdl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor5/URDL_Rooms/room_urdl_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor5/URDL_Rooms/room_urdl_miniboss.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor5/URDL_Rooms/room_urdl_boss.tscn"
			]
		},
		"urd": {
			"normal": [
				"res://scenes/Rooms/Floor5/URD_Rooms/room_urd.tscn",
				"res://scenes/Rooms/Floor5/URD_Rooms/room_urd_2.tscn"
				],
			"start": ["res://scenes/Rooms/Floor5/URD_Rooms/room_urd_start.tscn"],
			"item": ["res://scenes/Rooms/Floor5/URD_Rooms/room_urd_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor5/URD_Rooms/room_urd_miniboss.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor5/URD_Rooms/room_urd_boss.tscn"
			]
		},
		"rdl": {
			"normal": [
				"res://scenes/Rooms/Floor5/RDL_Rooms/room_rdl.tscn",
				"res://scenes/Rooms/Floor5/RDL_Rooms/room_rdl_2.tscn"
				],
			"start": ["res://scenes/Rooms/Floor5/RDL_Rooms/room_rdl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor5/RDL_Rooms/room_rdl_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor5/RDL_Rooms/room_rdl_miniboss.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor5/RDL_Rooms/room_rdl_boss.tscn"
			]
		},
		"udl": {
			"normal": [
				"res://scenes/Rooms/Floor5/UDL_Rooms/room_udl.tscn",
				"res://scenes/Rooms/Floor5/UDL_Rooms/room_udl_2.tscn"
				],
			"start": ["res://scenes/Rooms/Floor5/UDL_Rooms/room_udl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor5/UDL_Rooms/room_udl_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor5/UDL_Rooms/room_udl_miniboss.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor5/UDL_Rooms/room_udl_boss.tscn"
				]
		},
		"url": {
			"normal": [
				"res://scenes/Rooms/Floor5/URL_Rooms/room_url.tscn",
				"res://scenes/Rooms/Floor5/URL_Rooms/room_url_2.tscn"
				],
			"start": ["res://scenes/Rooms/Floor5/URL_Rooms/room_url_start.tscn"],
			"item": ["res://scenes/Rooms/Floor5/URL_Rooms/room_url_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor5/URL_Rooms/room_url_miniboss.tscn"],
			"boss": [
				"res://scenes/Rooms/Floor5/URL_Rooms/room_url_boss.tscn"
				]
		},
		"ur": {
			"normal": [
				"res://scenes/Rooms/Floor5/UR_Rooms/room_ur.tscn",
				"res://scenes/Rooms/Floor5/UR_Rooms/room_ur_2.tscn"
				],
			"start": ["res://scenes/Rooms/Floor5/UR_Rooms/room_ur_start.tscn"],
			"item": ["res://scenes/Rooms/Floor5/UR_Rooms/room_ur_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor5/UR_Rooms/room_ur_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor5/UR_Rooms/room_ur_boss.tscn"]
		},
		"ud": {
			"normal": [
				"res://scenes/Rooms/Floor5/UD_Rooms/room_ud.tscn",
				"res://scenes/Rooms/Floor5/UD_Rooms/room_ud_1.tscn",
				"res://scenes/Rooms/Floor5/UD_Rooms/room_ud_2.tscn"
				],
			"start": ["res://scenes/Rooms/Floor5/UD_Rooms/room_ud_start.tscn"],
			"item": ["res://scenes/Rooms/Floor5/UD_Rooms/room_ud_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor5/UD_Rooms/room_ud_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor5/UD_Rooms/room_ud_boss.tscn"]
		},
		"ul": {
			"normal": [
				"res://scenes/Rooms/Floor5/UL_Rooms/room_ul.tscn",
				"res://scenes/Rooms/Floor5/UL_Rooms/room_ul_2.tscn"
			],
			"start": ["res://scenes/Rooms/Floor5/UL_Rooms/room_ul_start.tscn"],
			"item": ["res://scenes/Rooms/Floor5/UL_Rooms/room_ul_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor5/UL_Rooms/room_ul_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor5/UL_Rooms/room_ul_boss.tscn"]
		},
		"rd": {
			"normal": [
				"res://scenes/Rooms/Floor5/RD_Rooms/room_rd_1.tscn",
				"res://scenes/Rooms/Floor5/RD_Rooms/room_rd.tscn"
				],
			"start": ["res://scenes/Rooms/Floor5/RD_Rooms/room_rd_start.tscn"],
			"item": ["res://scenes/Rooms/Floor5/RD_Rooms/room_rd_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor5/RD_Rooms/room_rd_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor5/RD_Rooms/room_rd_boss.tscn"]
		},
		"rl": {
			"normal": [
				"res://scenes/Rooms/Floor5/RL_Rooms/room_rl_1.tscn",
				"res://scenes/Rooms/Floor5/RL_Rooms/room_rl.tscn"
				],
			"start": ["res://scenes/Rooms/Floor5/RL_Rooms/room_rl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor5/RL_Rooms/room_rl_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor5/RL_Rooms/room_rl_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor5/RL_Rooms/room_rl_boss.tscn"]
		},
		"dl": {
			"normal": [
				"res://scenes/Rooms/Floor5/DL_Rooms/room_dl.tscn",
				"res://scenes/Rooms/Floor5/DL_Rooms/room_dl_1.tscn",
				"res://scenes/Rooms/Floor5/DL_Rooms/room_dl_2.tscn"
				],
			"start": ["res://scenes/Rooms/Floor5/DL_Rooms/room_dl_start.tscn"],
			"item": ["res://scenes/Rooms/Floor5/DL_Rooms/room_dl_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor5/DL_Rooms/room_dl_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor5/DL_Rooms/room_dl_boss.tscn"]
		},
		"u": {
			"normal": [
				"res://scenes/Rooms/Floor5/U_Rooms/room_u.tscn"
				],
			"start": ["res://scenes/Rooms/Floor5/U_Rooms/room_u_start.tscn"],
			"item": ["res://scenes/Rooms/Floor5/U_Rooms/room_u_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor5/U_Rooms/room_u_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor5/U_Rooms/room_u_boss.tscn"]
		},
		"r": {
			"normal": [
				"res://scenes/Rooms/Floor5/R_Rooms/room_r.tscn"
				],
			"start": ["res://scenes/Rooms/Floor5/R_Rooms/room_r_start.tscn"],
			"item": ["res://scenes/Rooms/Floor5/R_Rooms/room_r_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor5/R_Rooms/room_r_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor5/R_Rooms/room_r_boss.tscn"]
		},
		"d": {
			"normal": [
				"res://scenes/Rooms/Floor5/D_Rooms/room_d.tscn"
				],
			"start": ["res://scenes/Rooms/Floor5/D_Rooms/room_d_start.tscn"],
			"item": ["res://scenes/Rooms/Floor5/D_Rooms/room_d_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor5/D_Rooms/room_d_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor5/D_Rooms/room_d_boss.tscn"]
		},
		"l": {
			"normal": [
				"res://scenes/Rooms/Floor5/L_Rooms/room_l.tscn"
				],
			"start": ["res://scenes/Rooms/Floor5/L_Rooms/room_l_start.tscn"],
			"item": ["res://scenes/Rooms/Floor5/L_Rooms/room_l_item.tscn"],
			"miniboss": ["res://scenes/Rooms/Floor5/L_Rooms/room_l_miniboss.tscn"],
			"boss": ["res://scenes/Rooms/Floor5/L_Rooms/room_l_boss.tscn"]
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
