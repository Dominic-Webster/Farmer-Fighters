# Game
extends Node2D

@onready var room_parent : Node = $Room
@onready var player : Player = $Player
@onready var gui : PlayerHud = $PlayerHud
@onready var pause_menu : PauseMenu = $Pause


func _ready():
	RunManager.room_parent = room_parent
	RunManager.player = player
	RunManager.gui = gui
	
	gui.update_hp(player.current_health, player.get_max_health(), player.current_heart, player.num_hearts)
	player.damaged.connect(func(): gui.update_hp(player.current_health, player.get_max_health(), player.current_heart, player.num_hearts))
	
	RunManager.start_new_run(player)
	
	pause_menu.process_mode = Node.PROCESS_MODE_ALWAYS


func pause() -> void:
	pause_menu.show_menu()
	await get_tree().process_frame 
	get_tree().paused = true


func unpause() -> void:
	pause_menu.hide_menu()
	get_tree().paused = false


# Handle input for pausing
func _input(event):
	if event.is_action_pressed("pause") and not get_tree().paused:
		pause()
	elif event.is_action_pressed("pause"):
		unpause()
