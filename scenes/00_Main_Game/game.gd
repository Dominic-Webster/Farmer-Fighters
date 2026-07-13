# Game
extends Node2D

@onready var room_parent : Node = $Room
@onready var player : Player = $Player
@onready var gui : PlayerHud = $PlayerHud
@onready var pause_menu : PauseMenu = $Pause
@onready var end_menu : EndMenu = $End
@onready var audio_player : AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready():
	get_tree().paused = false
	RunManager.room_parent = room_parent
	RunManager.player = player
	RunManager.gui = gui
	
	RunManager.ended.connect(_run_ended)
	MapGenerationManager.new_floor.connect(_play_song)
	
	gui.update_hp(player.current_health, player.get_max_health(), player.current_heart, player.num_hearts)
	player.damaged.connect(func(): gui.update_hp(player.current_health, player.get_max_health(), player.current_heart, player.num_hearts))
	player.died.connect(_player_died)
	player.visible = true
	player.damaged.emit()
	
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


#func _play_song(num : int) -> void:
	#if num == 1:
		#audio_player.play()

func _play_song() -> void:
	audio_player.play()


func _player_died():
	end_menu.show_menu("You Died")
	await get_tree().process_frame 
	get_tree().paused = true


func _run_ended():
	end_menu.show_menu("You Win!")
	await get_tree().process_frame 
	get_tree().paused = true
