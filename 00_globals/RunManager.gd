# Run Manager
extends Node

var player : Player


func start_new_run(_player : Player):
	if _player:
		player = _player
