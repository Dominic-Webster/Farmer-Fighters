extends Node2D
class_name Room

@export var player_scene: PackedScene

func _ready():
	var player = player_scene.instantiate()
	player.global_position = $PlayerSpawn.global_position
	add_child(player)
