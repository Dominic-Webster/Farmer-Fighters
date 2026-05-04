extends Node2D
class_name Room

@export var player_scene: PackedScene
@onready var gui : PlayerHud = $PlayerHud

func _ready():
	var player = player_scene.instantiate()
	player.global_position = $PlayerSpawn.global_position
	add_child(player)
	
	if RunManager.player == null:
		RunManager.start_new_run(player)
	else:
		player = RunManager.player
	
	gui.update_hp(player.max_health, player.max_health)
	player.damaged.connect(func(): gui.update_hp(player.current_health, player.max_health))
