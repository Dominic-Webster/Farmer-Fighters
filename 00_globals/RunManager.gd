# Run Manager
extends Node

var player : Player
var current_room : Vector2i = Vector2i(0, 0)

func start_new_run(_player : Player):
	
	MapGenerationManager.create_new_map()
	current_room = MapGenerationManager._start
	print("Current room: ", str(current_room.x), ", ", str(current_room.y))
	
	if _player:
		player = _player
