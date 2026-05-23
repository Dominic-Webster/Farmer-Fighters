# Game
extends Node2D

@onready var room_parent : Node = $Room
@onready var player : Player = $Player
@onready var gui : PlayerHud = $PlayerHud


func _ready():
	RunManager.room_parent = room_parent
	RunManager.player = player
	RunManager.gui = gui

	gui.update_hp(player.current_health, player.get_max_health(), player.current_heart, player.num_hearts)
	player.damaged.connect(func(): gui.update_hp(player.current_health, player.get_max_health(), player.current_heart, player.num_hearts))

	RunManager.start_new_run(player)
