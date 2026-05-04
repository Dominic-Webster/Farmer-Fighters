extends Node2D

@onready var player : Player = $Player
@onready var gui : PlayerHud = $PlayerHud


func _ready() -> void:
	RunManager.start_new_run(player)
	gui.update_hp(player.max_health, player.max_health)
	player.damaged.connect(func(): gui.update_hp(player.current_health, player.max_health))
